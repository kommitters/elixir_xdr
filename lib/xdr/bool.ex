defmodule XDR.Bool do
  @moduledoc """
  This module is in charge of process the boolean types based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct boolean: nil

  @typedoc """
  Every boolean structure has a boolean value which you try to encode
  """
  @type t :: %XDR.Bool{boolean: boolean() | binary()}
  alias XDR.Error.Bool
  alias XDR.Int

  @doc """
  this function provides an easy way to create an XDR.Bool type

  returns a XDR.Bool struct with the value received as parameter
  """
  @spec new(boolean :: boolean() | binary()) :: XDR.Bool.t()
  def new(boolean), do: %XDR.Bool{boolean: boolean}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the boolean data into an XDR representation, it receives an XDR.Bool structure
  which contains the value to encode

  returns an ok tuple with the boolean encoded into an XDR value
  """
  @spec encode_xdr(t()) :: {:ok, binary()}
  def encode_xdr(%XDR.Bool{boolean: boolean}) when not is_boolean(boolean),
    do: raise(Bool, :not_boolean)

  def encode_xdr(%XDR.Bool{boolean: true}), do: Int.new(1) |> Int.encode_xdr()
  def encode_xdr(%XDR.Bool{boolean: false}), do: Int.new(0) |> Int.encode_xdr()

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the boolean data into an XDR representation, it receives an XDR.Bool structure
  which contains the value to encode

  returns the boolean encoded into an XDR value
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(boolean), do: encode_xdr(boolean) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value, it receives an XDR.Bool structure
  which contains the binary to decode

  returns an ok tuple with the boolean decoded from an XDR value
  """
  @spec decode_xdr(t()) :: {:ok, {boolean(), binary}}
  def decode_xdr(%XDR.Bool{boolean: <<1::big-signed-integer-size(32), rest::binary>>}),
    do: {:ok, {true, rest}}

  def decode_xdr(%XDR.Bool{boolean: <<0::big-signed-integer-size(32), rest::binary>>}),
    do: {:ok, {false, rest}}

  def decode_xdr(_invalid), do: raise(Bool, :invalid_value)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value, it receives an XDR.Bool structure
  which contains the binary to decode

  returns the boolean decoded from an XDR value
  """
  @spec decode_xdr!(t()) :: {boolean(), binary}
  def decode_xdr!(boolean), do: decode_xdr(boolean) |> elem(1)
end
