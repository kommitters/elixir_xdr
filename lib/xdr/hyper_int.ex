defmodule XDR.HyperInt do
  @moduledoc """
  This module is in charge of process the Hyper Integer types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.HyperInt

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Integer received by parameter if the parameters
  are wrong an error will be raised

    ## Parameters:
      -value: represents the Hyper Integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the XDR resulted from encoding the Hyper Integer value
  """
  @spec encode_xdr(integer(), any) :: {:ok, binary()}
  def encode_xdr(value, opts \\ nil)
  def encode_xdr(value, _opts) when not is_integer(value), do: raise(HyperInt, :not_integer)
  def encode_xdr(value, _opts) when value > 9_223_372_036_854_775_807, do: raise(HyperInt, :exceed_upper_limit)
  def encode_xdr(value, _opts) when value < -9_223_372_036_854_775_808, do: raise(HyperInt, :exceed_lower_limit)
  def encode_xdr(value, _opts), do: {:ok, <<value::big-signed-integer-size(64)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Integer received by parameter if the parameters
  are wrong an error will be raised

    ## Parameters:
      -value: represents the Hyper Integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns the XDR resulted from encoding the Hyper Integer value
  """
  @spec encode_xdr!(integer(), any) :: binary()
  def encode_xdr!(value, opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Hyper Integer
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the Hyper Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(binary(), any()) :: {:ok, {integer(), binary()}}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: raise(HyperInt, :not_binary)

  def decode_xdr(<<hyper_int::big-signed-integer-size(64), rest::binary>>, _opts),
    do: {:ok, {hyper_int, rest}}

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Hyper Integer
      -opts: it is an optional value required by the behaviour

  Returns the Hyper Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(binary(), any()) :: {integer(), binary()}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(binary, _opts), do: decode_xdr(binary) |> elem(1)
end
