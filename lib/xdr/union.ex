defmodule XDR.Union do
  @moduledoc """
  This module manages the `Discriminated Union` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Union, as: UnionError

  defstruct [:discriminant, :arms, :value]

  @typedoc """
  `XDR.Union` structure type specification.
  """
  @type t :: %XDR.Union{discriminant: XDR.Enum | XDR.Int | XDR.UInt, arms: list}

  @doc """
  Create a new `XDR.Union` structure with the `discriminant`, `arms` and `value` passed.
  """
  def new(discriminant, arms, value \\ nil),
    do: %XDR.Union{discriminant: discriminant, arms: arms, value: value}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Union` structure into a XDR format.
  """
  @spec encode_xdr(union :: t) :: {:ok, binary()} | {:error, :not_atom}
  def encode_xdr(%{discriminant: %{identifier: identifier}}) when not is_atom(identifier),
    do: {:error, :not_atom}

  def encode_xdr(%{
        discriminant: %{identifier: identifier} = discriminant,
        arms: arms,
        value: value
      }) do
    discriminant_module = discriminant.__struct__
    encoded_discriminant = discriminant_module.encode_xdr!(discriminant)

    encoded_arm = arms[identifier] |> encode_arm(value)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  def encode_xdr(%{discriminant: discriminant, arms: arms, value: value}) do
    discriminant_module = discriminant.__struct__
    encoded_discriminant = discriminant_module.encode_xdr!(discriminant)

    encoded_arm = arms[discriminant.datum] |> encode_arm(value)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Union` structure into a XDR format.
  If the `union` is not valid, an exception is raised.
  """
  @spec encode_xdr!(union :: t) :: binary()
  def encode_xdr!(union) do
    case encode_xdr(union) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(UnionError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Discriminated Union in XDR format to a `XDR.Union` structure.
  """
  @spec decode_xdr(bytes :: binary(), union :: t | map()) ::
          {:ok, {any, binary()}} | {:error, :not_binary | :not_list}
  def decode_xdr(bytes, union) do
    decode_union_discriminant(bytes, union)
    |> decode_union_arm()
  end

  @impl XDR.Declaration
  @doc """
  Decode the Discriminated Union in XDR format to a `XDR.Union` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), union :: t | map()) :: {any, binary()}
  def decode_xdr!(bytes, union) do
    case decode_xdr(bytes, union) do
      {:ok, result} -> result
      {:error, reason} -> raise(UnionError, reason)
    end
  end

  @spec decode_union_discriminant(bytes :: binary, struct :: map()) ::
          {struct(), binary} | {:error, :not_binary | :not_list}
  defp decode_union_discriminant(bytes, %{discriminant: %{declarations: _declarations}})
       when not is_binary(bytes),
       do: {:error, :not_binary}

  defp decode_union_discriminant(_bytes, %{discriminant: %{declarations: declarations}})
       when not is_list(declarations),
       do: {:error, :not_list}

  defp decode_union_discriminant(
         bytes,
         %{discriminant: %{declarations: declarations}} = union
       ) do
    {%{identifier: identifier}, rest} = XDR.Enum.decode_xdr!(bytes, %{declarations: declarations})

    {%{union | discriminant: identifier}, rest}
  end

  @spec decode_union_discriminant(bytes :: binary, union :: map()) :: {struct(), binary}
  defp decode_union_discriminant(bytes, _union) when not is_binary(bytes),
    do: {:error, :not_binary}

  defp decode_union_discriminant(bytes, %{discriminant: discriminant} = union) do
    discriminant_module = discriminant.__struct__
    {%{datum: datum}, rest} = discriminant_module.decode_xdr!(bytes)
    {%{union | discriminant: datum}, rest}
  end

  @spec encode_arm(arm :: struct() | module(), value :: any()) :: binary()
  defp encode_arm(%_{} = arm, nil) do
    arm_module = arm.__struct__
    arm_module.encode_xdr!(arm)
  end

  defp encode_arm(arm, value) when is_atom(arm) do
    arm.new(value) |> arm.encode_xdr!()
  end

  @spec decode_union_arm({:error, atom}) :: {:error, atom}
  defp decode_union_arm({:error, reason}), do: {:error, reason}

  @spec decode_union_arm({map(), binary}) :: {:ok, {{atom | integer, any}, binary}}
  defp decode_union_arm({%{discriminant: discriminant, arms: arms}, rest}) do
    arm_module = arms[discriminant] |> get_arm_module()
    {decoded_arm, rest} = arm_module.decode_xdr!(rest)
    {:ok, {{discriminant, decoded_arm}, rest}}
  end

  @spec get_arm_module(arm :: struct() | module()) :: module()
  defp get_arm_module(%_{} = arm), do: arm.__struct__
  defp get_arm_module(arm) when is_atom(arm), do: arm
end
