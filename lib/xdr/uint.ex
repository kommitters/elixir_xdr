defmodule XDR.UInt do
  @moduledoc """
  This module is in charge of process the unsigned integer types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.UInt

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding an unsigned integers into an XDR if the parameters are wrong
  an error will be raised

    ## Parameters:
      -value: represents an unsigned integer value which you try to encode into a XDR value
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the XDR resulted from encode the unsigned integer value
  """
  def encode_xdr(value, opts \\ nil)
  def encode_xdr(value, _opts) when not is_integer(value), do: raise(UInt, :not_integer)
  def encode_xdr(value, _opts) when value > 4_294_967_295, do: raise(UInt, :exceed_upper_limit)
  def encode_xdr(value, _opts) when value < 0, do: raise(UInt, :exceed_lower_limit)
  def encode_xdr(value, _opts), do: {:ok, <<value::big-unsigned-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding an unsigned integers into an XDR if the parameters are wrong
  an error will be raised

    ## Parameters:
      -value: represents an unsigned integer value which you try to encode into a XDR value
      -opts: it is an optional value required by the behaviour

  Returns the XDR resulted from encode the unsigned integer value
  """
  def encode_xdr!(value, opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an unsigned integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an unsigned integer
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the integer resulted from decode the XDR value
  """
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: raise(UInt, :not_binary)

  def decode_xdr(<<uint::big-unsigned-integer-size(32), rest::binary>>, _opts),
    do: {:ok, {uint, rest}}

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an unsigned integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an unsigned integer
      -opts: it is an optional value required by the behaviour

  Returns the integer resulted from decode the XDR value
  """
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(bytes, _opts), do: decode_xdr(bytes) |> elem(1)
end
