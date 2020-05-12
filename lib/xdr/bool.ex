defmodule XDR.Bool do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of process the boolean types based on the RFC4056 XDR Standard
  """
  alias XDR.Enum
  alias XDR.Error.Bool

  @boolean [false: 0, true: 1]

  defstruct declarations: @boolean, identifier: nil

  @type t :: %XDR.Bool{declarations: keyword(), identifier: boolean()}

  @spec new(atom()) :: t()
  def new(identifier), do: %XDR.Bool{declarations: @boolean, identifier: identifier}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

  returns an ok tuple with the boolean encoded into an XDR value
  """
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.Bool{identifier: identifier}) when not is_boolean(identifier),
    do: raise(Bool, :not_boolean)

  def encode_xdr(%XDR.Bool{} = boolean), do: Enum.encode_xdr(boolean)

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

  returns the boolean encoded into an XDR value
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(boolean), do: encode_xdr(boolean) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

  returns an ok tuple with the boolean decoded from an XDR value
  """
  @spec decode_xdr(bytes :: binary, struct :: t | any) :: {:ok, {t, binary}}
  def decode_xdr(bytes, struct \\ %XDR.Bool{declarations: @boolean})
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: raise(Bool, :invalid_value)

  def decode_xdr(bytes, struct) do
    {enum, rest} = Enum.decode_xdr!(bytes, struct)

    decoded_bool = new(enum.identifier)

    {:ok, {decoded_bool, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

  returns the boolean decoded from an XDR value
  """
  @spec decode_xdr!(bytes :: binary, struct :: t | any) :: {t(), binary}
  def decode_xdr!(bytes, struct \\ %XDR.Bool{declarations: @boolean})
  def decode_xdr!(bytes, struct), do: decode_xdr(bytes, struct) |> elem(1)
end
