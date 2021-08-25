defmodule XDR.Float do
  @moduledoc """
  This module manages the `Floating-Point` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Float, as: FloatError

  defstruct [:float]

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @type float_number :: integer() | float() | binary()

  @typedoc """
  `XDR.Float` structure type specification.
  """
  @type t :: %XDR.Float{float: float_number()}

  @doc """
  Create a new `XDR.Float` structure with the `float` passed.
  """
  @spec new(float :: float_number()) :: t()
  def new(float), do: %XDR.Float{float: float}

  @doc """
  Encode a `XDR.Float` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%XDR.Float{float: float}) when not valid_float?(float),
    do: {:error, :not_number}

  def encode_xdr(%XDR.Float{float: float}), do: {:ok, <<float::big-signed-float-size(32)>>}

  @doc """
  Encode a `XDR.Float` structure into a XDR format.
  If the `float` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(float) do
    case encode_xdr(float) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(FloatError, reason)
    end
  end

  @doc """
  Decode the Floating-Point in XDR format to a `XDR.Float` structure.
  """
  @impl true
  def decode_xdr(bytes, float \\ nil)

  def decode_xdr(bytes, _float) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(<<float::big-signed-float-size(32), rest::binary>>, _float),
    do: {:ok, {new(float), rest}}

  @doc """
  Decode the Floating-Point in XDR format to a `XDR.Float` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, float \\ nil)

  def decode_xdr!(bytes, float) do
    case decode_xdr(bytes, float) do
      {:ok, result} -> result
      {:error, reason} -> raise(FloatError, reason)
    end
  end
end
