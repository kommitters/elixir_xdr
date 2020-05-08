defmodule XDR.HyperUInt do
  @moduledoc """
  This module is in charge of process the Hyper Unsigned Integer types based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct datum: nil

  @typedoc """
  Every integer structure has a datum which represent the integer value which you try to encode
  """
  @type t :: %XDR.HyperUInt{datum: integer | binary}

  alias XDR.Error.HyperUInt

  @doc """
  this function provides an easy way to create an XDR.HyperUInt type

  returns a XDR.HyperInt struct with the value received as parameter
  """
  @spec new(datum :: integer | binary) :: t()
  def new(datum), do: %XDR.HyperUInt{datum: datum}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Unsigned Integer received by parameter if the parameters
  are wrong an error will be raised, it recieves an XDR.HyperUInt structure which contains the hyper int

  Returns a tuple with the XDR resulted from encoding the Hyper Unsigned Integer value
  """
  @spec encode_xdr(t()) :: {:ok, binary()}
  def encode_xdr(%XDR.HyperUInt{datum: datum}) when not is_integer(datum),
    do: raise(HyperUInt, :not_integer)

  def encode_xdr(%XDR.HyperUInt{datum: datum}) when datum > 18_446_744_073_709_551_615,
    do: raise(HyperUInt, :exceed_upper_limit)

  def encode_xdr(%XDR.HyperUInt{datum: datum}) when datum < 0,
    do: raise(HyperUInt, :exceed_lower_limit)

  def encode_xdr(%XDR.HyperUInt{datum: datum}),
    do: {:ok, <<datum::big-unsigned-integer-size(64)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Unsigned Integer received by parameter if the parameters
  are wrong an error will be raised, it recieves an XDR.HyperUInt structure which contains the hyper int

  Returns the XDR resulted from encoding the Hyper Unsigned Integer value
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(datum), do: encode_xdr(datum) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Unsigned Integer value if the parameters are wrong
  an error will be raised, it recieves an XDR.HyperUInt structure which contains the binary value

  Returns a tuple with the Hyper Unsigned Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(t()) :: {:ok, {integer(), binary()}}
  def decode_xdr(%XDR.HyperUInt{datum: datum}) when not is_binary(datum),
    do: raise(HyperUInt, :not_binary)

  def decode_xdr(%XDR.HyperUInt{datum: datum}) do
    <<hyper_int::big-unsigned-integer-size(64), rest::binary>> = datum
    {:ok, {hyper_int, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Unsigned Integer value if the parameters are wrong
  an error will be raised, it recieves an XDR.HyperUInt structure which contains the binary value

  Returns the Hyper Unsigned Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(t()) :: {integer(), binary()}
  def decode_xdr!(datum), do: decode_xdr(datum) |> elem(1)
end
