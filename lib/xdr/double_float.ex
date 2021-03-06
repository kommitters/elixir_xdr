defmodule XDR.DoubleFloat do
  @moduledoc """
  This module manages the `Double-Precision Floating-Point` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.DoubleFloat, as: DoubleFloatError

  defstruct [:float]

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @typedoc """
  `XDR.DoubleFloat` struct type specification.
  """
  @type t :: %XDR.DoubleFloat{float: integer | float | binary}

  @doc """
  Create a new `XDR.DoubleFloat` structure from the `float` passed.
  """
  @spec new(float :: float | integer | binary) :: t
  def new(float), do: %XDR.DoubleFloat{float: float}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.DoubleFloat` structure into a XDR format.
  """
  @spec encode_xdr(double_float :: t) :: {:ok, binary()} | {:error, :not_number}
  def encode_xdr(%XDR.DoubleFloat{float: float}) when not valid_float?(float),
    do: {:error, :not_number}

  def encode_xdr(%XDR.DoubleFloat{float: float}), do: {:ok, <<float::big-signed-float-size(64)>>}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.DoubleFloat` structure into a XDR format.
  If the `double_float` is not valid, an exception is raised.
  """
  @spec encode_xdr!(double_float :: t) :: binary()
  def encode_xdr!(double_float) do
    case encode_xdr(double_float) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(DoubleFloatError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Double-Precision Floating-Point in XDR format to a `XDR.DoubleFloat` structure.
  """
  @spec decode_xdr(bytes :: binary, double_float :: t) ::
          {:ok, {t, binary()}} | {:error, :not_binary}
  def decode_xdr(bytes, double_float \\ nil)
  def decode_xdr(bytes, _double_float) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _double_float) do
    <<float::big-signed-float-size(64), rest::binary>> = bytes

    decoded_float = new(float)

    {:ok, {decoded_float, rest}}
  end

  @impl XDR.Declaration
  @doc """
  Decode the Double-Precision Floating-Point in XDR format to a `XDR.DoubleFloat` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary, double_float :: t) :: {t, binary()}
  def decode_xdr!(bytes, double_float \\ nil)

  def decode_xdr!(bytes, double_float) do
    case decode_xdr(bytes, double_float) do
      {:ok, result} -> result
      {:error, reason} -> raise(DoubleFloatError, reason)
    end
  end
end
