defmodule XDR.DoubleFloat do
  @moduledoc """
  This module is in charge of process the Double-Precision Floating-Point types based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct float: nil

  @typedoc """
  Every double float structure has a float which represent the Double-Precision Floating-Point value which you try to encode
  """
  @type t :: %XDR.DoubleFloat{float: integer | float | binary}

  alias XDR.Error.DoubleFloat

  @doc """
  this function provides an easy way to create an XDR.DoubleFloat type

  returns a XDR.DoubleFloat struct with the value received as parameter
  """
  @spec new(float :: integer | binary) :: t()
  def new(float), do: %XDR.DoubleFloat{float: float}

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a Double Floating Point value into an XDR if the parameters are wrong an error will be raised,
  it receives an XDR.DoubleFloat structure which contains the Double-Precision Floating-Point to encode

  Returns a tuple with the XDR resulted from encoding the Double Floating Point value
  """
  @spec encode_xdr(t()) :: {:ok, binary()}
  def encode_xdr(%XDR.DoubleFloat{float: float}) when not valid_float?(float),
    do: raise(DoubleFloat, :not_number)

  def encode_xdr(%XDR.DoubleFloat{float: float}), do: {:ok, <<float::big-signed-float-size(64)>>}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding a Double Floating Point value into an XDR if the parameters are wrong an error will be raised,
  it receives an XDR.DoubleFloat structure which contains the Double-Precision Floating-Point to encode

  Returns the XDR resulted from encoding the Double Floating Point value
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(float), do: encode_xdr(float) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Double Floating Point value if the parameters are wrong
  an error will be raised, it receives an XDR.DoubleFloat structure which contanis the binary to decode

  Returns a tuple with the Double Floating Point resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(t()) :: {:ok, {float(), binary()}}
  def decode_xdr(%XDR.DoubleFloat{float: float}) when not is_binary(float),
    do: raise(DoubleFloat, :not_binary)

  def decode_xdr(%XDR.DoubleFloat{float: float}) do
    <<int::big-signed-float-size(64), rest::binary>> = float
    {:ok, {int, rest}}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Double Floating Point value if the parameters are wrong
  an error will be raised, it receives an XDR.DoubleFloat structure which contanis the binary to decode

  Returns the Double Floating Point resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(t()) :: {float(), binary()}
  def decode_xdr!(float), do: decode_xdr(float) |> elem(1)
end
