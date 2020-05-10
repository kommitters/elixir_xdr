defmodule XDR.Union do
  @moduledoc """
  this module is in charge of process the Discriminated Union types based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct discriminant: nil, arms: nil

  @type t :: %XDR.Union{discriminant: XDR.Enum | XDR.Int | XDR.UInt, arms: list}

  alias XDR.Error.Union

  def new(discriminant, arms \\ nil)
  def new(discriminant, arms), do: %{discriminant: discriminant, arms: arms}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the Discriminated Union types, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant

  returns an ok tuple which contains the binary encoded of the union
  """
  @spec encode_xdr(struct()) :: {:ok, binary()}
  def encode_xdr(%{discriminant: %{identifier: identifier}}) when not is_atom(identifier),
    do: raise(Union, :not_atom)

  def encode_xdr(%{
        discriminant: %{identifier: identifier} = discriminant,
        arms: arms,
        struct: struct
      }) do
    discriminant_module = struct.discriminant
    encoded_discriminant = discriminant_module.encode_xdr!(discriminant)

    arm = arms[identifier]
    arm_module = arm.__struct__
    encoded_arm = arm_module.encode_xdr!(arm)

    {:ok, encoded_discriminant <> encoded_arm}
  end

  def encode_xdr(%{discriminant: discriminant, arms: arms, struct: struct}) do
    discriminant_module = struct.discriminant
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
  def encode_xdr!(union), do: encode_xdr(union) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the XDR which represents an Disxriminated Union type, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant, and the specific
  struct

  returns an ok tuple which contains the values of the union
  """
  @spec decode_xdr(struct()) :: {:ok, {any, binary()}}
  def decode_xdr(union) do
    union
    |> decode_union_discriminant
    |> decode_union_arm
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the XDR which represents an Disxriminated Union type, it receives a struct which contains the discriminant
  which is the principal value to make the Union, and the arms which are the possible values that can be taken by the discriminant, and the specific
  struct

  returns the values of the union
  """
  @spec decode_xdr!(struct()) :: {any, binary()}
  def decode_xdr!(union), do: decode_xdr(union) |> elem(1)

  defp decode_union_discriminant(%{discriminant: %{identifier: identifier}})
       when not is_binary(identifier),
       do: raise(Union, :not_binary)

  defp decode_union_discriminant(%{discriminant: %{declarations: declarations}})
       when not is_list(declarations),
       do: raise(Union, :not_list)

  defp decode_union_discriminant(
         %{discriminant: %{identifier: identifier, declarations: declarations}, struct: struct} =
           union
       ) do
    discriminant_module = struct.discriminant

    {decoded_discriminant, rest} =
      discriminant_module.new(declarations, identifier)
      |> discriminant_module.decode_xdr!()

    {%{union | discriminant: decoded_discriminant}, rest}
  end

  @spec decode_union_discriminant(struct()) :: {struct(), binary}
  defp decode_union_discriminant(%{discriminant: discriminant}) when not is_binary(discriminant),
    do: raise(Union, :not_binary)

  defp decode_union_discriminant(%{discriminant: discriminant, struct: struct} = union) do
    discriminant_module = struct.discriminant

    {decoded_discriminant, rest} =
      discriminant_module.new(discriminant)
      |> discriminant_module.decode_xdr!()

    {%{union | discriminant: decoded_discriminant}, rest}
  end

  @spec decode_union_arm({struct(), binary}) :: {:ok, {{atom | integer, any}, binary}}
  defp decode_union_arm({%{discriminant: discriminant, arms: arms}, rest}) do
    arm = arms[discriminant]
    arm_module = arm.__struct__

    {decoded_arm, rest} =
      arm_module.new(rest)
      |> arm_module.decode_xdr!()

    {:ok, {{discriminant, decoded_arm}, rest}}
  end
end
