defmodule XDR.Float do
  @moduledoc """
  This module is in charge of process the Single-Precision Floating-Point types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.Float

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a Floating Point value into an XDR if the parameters are wrong an error will be raised

    ## Parameters:
      -value: represents the Floating Point value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the XDR resulted from encoding the Floating Point value
  """
  @spec encode_xdr(float(), any) :: {:ok, binary()}
  def encode_xdr(value, opts \\ nil)
  def encode_xdr(value, _opts) when not valid_float?(value), do: raise(Float, :not_number)
  def encode_xdr(value, _opts), do: {:ok, <<value::big-signed-float-size(32)>>}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a Floating Point value into an XDR if the parameters are wrong an error will be raised

    ## Parameters:
      -value: represents the Floating Point value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns the XDR resulted from encoding the Floating Point value
  """
  @spec encode_xdr!(float(), any) :: binary()
  def encode_xdr!(value, opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Floating Point value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Floating Point
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the Floating Point resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(binary(), any()) :: {:ok, {float(), binary()}}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: raise(Float, :not_binary)

  def decode_xdr(<<int::big-signed-float-size(32), rest::binary>>, _opts),
    do: {:ok, {int, rest}}

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Floating Point value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Floating Point
      -opts: it is an optional value required by the behaviour

  Returns the Floating Point resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(binary(), any()) :: {float(), binary()}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(binary, _opts), do: decode_xdr(binary) |> elem(1)
end
