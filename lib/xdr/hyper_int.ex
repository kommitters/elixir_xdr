defmodule XDR.HyperInt do
  @moduledoc """
  This module is in charge of process the Hyper Integer types based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct datum: nil

  @typedoc """
  Every integer structure has a datum which represent the integer value which you try to encode
  """
  @type t :: %XDR.HyperInt{datum: integer | binary}

  alias XDR.Error.HyperInt

  @doc """
  this function provides an easy way to create an XDR.HyperInt type

  returns a XDR.HyperInt struct with the value received as parameter
  """
  @spec new(datum :: integer | binary) :: t()
  def new(datum), do: %XDR.HyperInt{datum: datum}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Integer received by parameter if the parameters
  are wrong an error will be raised, it recieves an XDR.HyperInt structure which contains the hyper int

  Returns a tuple with the XDR resulted from encoding the Hyper Integer value
  """
  @spec encode_xdr(t()) :: {:ok, binary()}
  def encode_xdr(%XDR.HyperInt{datum: datum}) when not is_integer(datum),
    do: raise(HyperInt, :not_integer)

  def encode_xdr(%XDR.HyperInt{datum: datum}) when datum > 9_223_372_036_854_775_807,
    do: raise(HyperInt, :exceed_upper_limit)

  def encode_xdr(%XDR.HyperInt{datum: datum}) when datum < -9_223_372_036_854_775_808,
    do: raise(HyperInt, :exceed_lower_limit)

  def encode_xdr(%XDR.HyperInt{datum: datum}), do: {:ok, <<datum::big-signed-integer-size(64)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Integer received by parameter if the parameters
  are wrong an error will be raised, it recieves an XDR.HyperInt structure which contains the hyper int

  Returns the XDR resulted from encoding the Hyper Integer value
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(datum), do: encode_xdr(datum) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Integer value if the parameters are wrong
  an error will be raised, it receives an XDR.HyperInt structure which contains the binary to decode

  Returns a tuple with the Hyper Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(bytes :: binary, opts :: any) :: {:ok, {t(), binary()}}
  def decode_xdr(bytes, opts \\ nil)

  def decode_xdr(bytes, _opts) when not is_binary(bytes),
    do: raise(HyperInt, :not_binary)

  def decode_xdr(bytes, _opts) do
    <<hyper_int::big-signed-integer-size(64), rest::binary>> = bytes

    decoded_hyper_int = new(hyper_int)

    {:ok, {decoded_hyper_int, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Integer value if the parameters are wrong
  an error will be raised, it receives an XDR.HyperInt structure which contains the binary to decode

  Returns the Hyper Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(bytes :: binary, opts :: any) :: {t(), binary()}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(bytes, opts), do: decode_xdr(bytes, opts) |> elem(1)
end
