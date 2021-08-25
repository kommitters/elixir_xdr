defmodule XDR.DoubleFloat do
  @moduledoc """
  This module manages the `Double-Precision Floating-Point` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.DoubleFloat, as: DoubleFloatError

  defstruct [:float]

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @type float_number :: integer() | float() | binary()

  @typedoc """
  `XDR.DoubleFloat` struct type specification.
  """
  @type t :: %XDR.DoubleFloat{float: float_number()}

  @doc """
  Create a new `XDR.DoubleFloat` structure from the `float` passed.
  """
  @spec new(float :: float_number()) :: t()
  def new(float), do: %XDR.DoubleFloat{float: float}

  @doc """
  Encode a `XDR.DoubleFloat` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%XDR.DoubleFloat{float: float}) when not valid_float?(float),
    do: {:error, :not_number}

  def encode_xdr(%XDR.DoubleFloat{float: float}), do: {:ok, <<float::big-signed-float-size(64)>>}

  @doc """
  Encode a `XDR.DoubleFloat` structure into a XDR format.
  If the `double_float` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(double_float) do
    case encode_xdr(double_float) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(DoubleFloatError, reason)
    end
  end

  @doc """
  Decode the Double-Precision Floating-Point in XDR format to a `XDR.DoubleFloat` structure.
  """
  @impl true
  def decode_xdr(bytes, double_float \\ nil)
  def decode_xdr(bytes, _double_float) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _double_float) do
    <<float::big-signed-float-size(64), rest::binary>> = bytes

    decoded_float = new(float)

    {:ok, {decoded_float, rest}}
  end

  @doc """
  Decode the Double-Precision Floating-Point in XDR format to a `XDR.DoubleFloat` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, double_float \\ nil)

  def decode_xdr!(bytes, double_float) do
    case decode_xdr(bytes, double_float) do
      {:ok, result} -> result
      {:error, reason} -> raise(DoubleFloatError, reason)
    end
  end
end
