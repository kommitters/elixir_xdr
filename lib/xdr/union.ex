defmodule XDR.Union do
  @behaviour XDR.Declaration
  @moduledoc """
  this module is in charge of process the Discriminated Union types based on the RFC4506 XDR Standard
  """

  defstruct discriminant: nil, arms: nil

  @type t :: %XDR.Union{discriminant: XDR.Enum | XDR.Int | XDR.UInt, arms: list}

  alias XDR.Error.Union

  def new({%{identifier: identifier} = discriminant, value}, arms) when not is_nil(value) do
    arm_type = arms[identifier]
    arm = arm_type.new(value)
    new_arms = Keyword.replace!(arms, identifier, arm)

    %XDR.Union{discriminant: discriminant, arms: new_arms}
  end

  def new(discriminant, arms), do: %XDR.Union{discriminant: discriminant, arms: arms}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the Discriminated Union types, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant

  returns an ok tuple which contains the binary encoded of the union
  """
  @spec encode_xdr(map()) :: {:ok, binary()} | {:error, :not_atom}
  def encode_xdr(%{discriminant: %{identifier: identifier}}) when not is_atom(identifier),
    do: {:error, :not_atom}

  def encode_xdr(%{
        discriminant: %{identifier: identifier} = discriminant,
        arms: arms
      }) do
    discriminant_module = discriminant.__struct__
    encoded_discriminant = discriminant_module.encode_xdr!(discriminant)

    arm = arms[identifier]
    arm_module = arm.__struct__
    encoded_arm = arm_module.encode_xdr!(arm)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  def encode_xdr(%{discriminant: discriminant, arms: arms}) do
    discriminant_module = discriminant.__struct__
    encoded_discriminant = discriminant_module.encode_xdr!(discriminant)

    arm = arms[discriminant.datum]
    arm_module = arm.__struct__
    encoded_arm = arm_module.encode_xdr!(arm)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the Discriminated Union types, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant

  returns the binary encoded of the union
  """
  @spec encode_xdr!(map()) :: binary()
  def encode_xdr!(union) do
    case encode_xdr(union) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(Union, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the XDR which represents an Disxriminated Union type, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant, and the specific
  struct

  returns an ok tuple which contains the values of the union
  """
  @spec decode_xdr(bytes :: binary(), union :: map()) ::
          {:ok, {any, binary()}} | {:error, :not_binary | :not_list}
  def decode_xdr(bytes, union) do
    decode_union_discriminant(bytes, union)
    |> decode_union_arm()
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the XDR which represents an Disxriminated Union type, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant, and the specific
  struct

  returns the values of the union
  """
  @spec decode_xdr!(bytes :: binary(), union :: map()) :: {any, binary()}
  def decode_xdr!(bytes, union) do
    case decode_xdr(bytes, union) do
      {:ok, result} -> result
      {:error, reason} -> raise(Union, reason)
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
         %{discriminant: {%{declarations: declarations}, _value}} = union
       ) do
    {%{identifier: identifier}, rest} = XDR.Enum.decode_xdr!(bytes, %{declarations: declarations})

    {%{union | discriminant: identifier}, [value: rest]}
  end

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

  @spec decode_union_arm({:error, atom}) :: {:error, atom}
  defp decode_union_arm({:error, reason}), do: {:error, reason}

  @spec decode_union_arm({map(), binary}) :: {:ok, {{atom | integer, any}, binary}}
  defp decode_union_arm({%{discriminant: discriminant, arms: arms}, [value: value]}) do
    arm = arms[discriminant]

    {decoded_arm, rest} = arm.decode_xdr!(value)

    {:ok, {{discriminant, decoded_arm}, rest}}
  end

  @spec decode_union_arm({map(), binary}) :: {:ok, {{atom | integer, any}, binary}}
  defp decode_union_arm({%{discriminant: discriminant, arms: arms}, rest}) do
    arm = arms[discriminant]
    arm_module = arm.__struct__

    {decoded_arm, rest} = arm_module.decode_xdr!(rest)

    {:ok, {{discriminant, decoded_arm}, rest}}
  end
end
