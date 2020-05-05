defmodule XDR.Bool do
  @moduledoc """
  This module is in charge of process the boolean types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.Bool
  alias XDR.Int

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

    ## Parameters:
      - value: represents the boolean which you need to encode
      - opts: it is an optional value required by the behaviour

    returns an ok tuple with the boolean encoded into an XDR value
  """
  @spec encode_xdr(boolean(), any) :: {:ok, binary()}
  def encode_xdr(value, _opts \\ nil)
  def encode_xdr(value, _opts) when not is_boolean(value), do: raise(Bool, :not_boolean)
  def encode_xdr(true, _opts), do: Int.encode_xdr(1)
  def encode_xdr(false, _opts), do: Int.encode_xdr(0)

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

    ## Parameters:
      - value: represents the boolean which you need to encode
      - opts: it is an optional value required by the behaviour

    returns the boolean encoded into an XDR value
  """
  @spec encode_xdr!(boolean(), any) :: binary()
  def encode_xdr!(value, _opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

    ## Parameters:
      - bytes: represents the XDR value which represents the boolean value into @boolean
      - opts: it is an optional value required by the behaviour

    returns an ok tuple with the boolean decoded from an XDR value
  """
  @spec decode_xdr(binary(), any) :: {:ok, {boolean(), binary}}
  def decode_xdr(bytes, _opts \\ nil)
  def decode_xdr(<<1::big-signed-integer-size(32), rest::binary>>, _opts), do: {:ok, {true, rest}}

  def decode_xdr(<<0::big-signed-integer-size(32), rest::binary>>, _opts),
    do: {:ok, {false, rest}}

  def decode_xdr(_invalid, _opts), do: raise(Bool, :invalid_value)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

    ## Parameters:
      - bytes: represents the XDR value which represents the boolean value into @boolean
      - opts: it is an optional value required by the behaviour

    returns the boolean decoded from an XDR value
  """
  @spec decode_xdr!(binary(), any) :: {boolean(), binary}
  def decode_xdr!(bytes, _opts \\ nil)
  def decode_xdr!(bytes, _opts), do: decode_xdr(bytes) |> elem(1)
end
