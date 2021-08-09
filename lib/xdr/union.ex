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
  @type t :: %XDR.Union{
          discriminant: XDR.Enum.t() | XDR.Int.t() | XDR.UInt.t(),
          arms: keyword() | map()
        }

  @doc """
  Create a new `XDR.Union` structure with the `discriminant`, `arms` and `value` passed.
  """
  @spec new(
          discriminant :: XDR.Enum.t() | XDR.Int.t() | XDR.UInt.t(),
          arms :: keyword() | map(),
          value :: any()
        ) :: t
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
        discriminant: %{__struct__: xdr_type, identifier: identifier} = discriminant,
        arms: arms,
        value: value
      }) do
    encoded_discriminant = xdr_type.encode_xdr!(discriminant)
    encoded_arm = identifier |> get_arm(arms) |> encode_arm(value)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  def encode_xdr(%{
        discriminant: %{__struct__: xdr_type, datum: datum} = discriminant,
        arms: arms,
        value: value
      }) do
    encoded_discriminant = xdr_type.encode_xdr!(discriminant)
    encoded_arm = datum |> get_arm(arms) |> encode_arm(value)

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
    bytes
    |> decode_union_discriminant(union)
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
  defp decode_union_discriminant(bytes, _union) when not is_binary(bytes),
    do: {:error, :not_binary}

  defp decode_union_discriminant(_bytes, %{discriminant: %{declarations: declarations}})
       when not is_list(declarations),
       do: {:error, :not_list}

  defp decode_union_discriminant(
         bytes,
         %{discriminant: %{__struct__: xdr_type, declarations: declarations}} = union
       ) do
    {discriminant, rest} = xdr_type.decode_xdr!(bytes, %{declarations: declarations})
    {%{union | discriminant: discriminant}, rest}
  end

  defp decode_union_discriminant(bytes, %{discriminant: %{__struct__: xdr_type}} = union) do
    case xdr_type.decode_xdr!(bytes) do
      {%{datum: datum}, rest} ->
        {%{union | discriminant: datum}, rest}

      {discriminant, rest} ->
        {%{union | discriminant: discriminant}, rest}
    end
  end

  @spec encode_arm(arm :: struct() | atom() | module(), value :: any()) :: binary()
  defp encode_arm(xdr_type, %{__struct__: xdr_type} = value) do
    xdr_type.encode_xdr!(value)
  end

  defp encode_arm(arm, value) when is_atom(arm) do
    value |> arm.new() |> arm.encode_xdr!()
  end

  defp encode_arm(%{__struct__: xdr_type} = arm, nil) do
    xdr_type.encode_xdr!(arm)
  end

  @spec decode_union_arm({:error, atom}) :: {:error, atom}
  defp decode_union_arm({:error, reason}), do: {:error, reason}

  @spec decode_union_arm({struct(), binary}) :: {:ok, {{atom | integer, any}, binary}}
  defp decode_union_arm(
         {%{discriminant: %{identifier: identifier} = discriminant, arms: arms}, rest}
       ) do
    arm_module = identifier |> get_arm(arms) |> get_arm_module()
    {decoded_arm, rest} = arm_module.decode_xdr!(rest)
    {:ok, {{discriminant, decoded_arm}, rest}}
  end

  defp decode_union_arm({%{discriminant: discriminant, arms: arms}, rest}) do
    arm_module = discriminant |> get_arm(arms) |> get_arm_module()
    {decoded_arm, rest} = arm_module.decode_xdr!(rest)
    {:ok, {{discriminant, decoded_arm}, rest}}
  end

  @spec get_arm_module(arm :: struct() | module()) :: module()
  defp get_arm_module(%{__struct__: xdr_type}), do: xdr_type
  defp get_arm_module(arm) when is_atom(arm), do: arm

  @spec get_arm(identifier :: atom() | number(), arms :: keyword() | map()) ::
          struct() | module() | nil
  defp get_arm(identifier, arms) do
    case arms[identifier] do
      nil -> arms[:default]
      arm -> arm
    end
  end
end
