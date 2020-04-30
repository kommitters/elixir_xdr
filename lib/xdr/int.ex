defmodule XDR.Int do
  @moduledoc """
  This module is in charge of process the integer types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.Int

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding a value inside of the enum structure based on the identifier received by parameter
  if the parameters are wrong an error will be raised

    ## Parameters:
      -value: represents the integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the binary resulted from encoding the integer value
  """
  @spec encode_xdr(integer(), any) :: {:ok, binary()}
  def encode_xdr(value, opts \\ nil)
  def encode_xdr(value, _opts) when not is_integer(value), do: raise(Int, :not_integer)
  def encode_xdr(value, _opts) when value > 2_147_483_647, do: raise(Int, :exceed_upper_limit)
  def encode_xdr(value, _opts) when value < -2_147_483_648, do: raise(Int, :exceed_lower_limit)
  def encode_xdr(value, _opts), do: {:ok, <<value::big-signed-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding a value inside of the enum structure based on the identifier received by parameter
  if the parameters are wrong an error will be raised

    ## Parameters:
      -value: represents the integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns the binary resulted from encoding the integer value
  """
  @spec encode_xdr!(integer(), any) :: binary()
  def encode_xdr!(value, opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the binary value which represents an integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the binary value which needs to decode into an integer
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the integer resulted from decode the binary value and its remaining bits
  """
  @spec decode_xdr(binary(), any()) :: {:ok, {integer(), binary()}}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: raise(Int, :not_binary)

  def decode_xdr(<<int::big-signed-integer-size(32), rest::binary>>, _opts),
    do: {:ok, {int, rest}}

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the binary value which represents an integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the binary value which needs to decode into an integer
      -opts: it is an optional value required by the behaviour

  Returns the integer resulted from decode the binary value and its remaining bits
  """
  @spec decode_xdr!(binary(), any()) :: {integer(), binary()}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(binary, _opts), do: decode_xdr(binary) |> elem(1)
end
