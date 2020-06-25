defmodule XDR.Float do
  @moduledoc """
  This module manages the `Floating-Point` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Float, as: FloatError

  defstruct [:float]

  defguard valid_float?(value) when is_float(value) or is_integer(value)

  @typedoc """
  `XDR.Float` structure type specification.
  """
  @type t :: %XDR.Float{float: integer | float | binary}

  @doc """
  Create a new `XDR.Float` structure with the `float` passed.
  """
  @spec new(float :: float | integer | binary) :: t
  def new(float), do: %XDR.Float{float: float}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Float` structure into a XDR format.
  """
  @spec encode_xdr(float :: t) :: {:ok, binary} | {:error, :not_number}
  def encode_xdr(%XDR.Float{float: float}) when not valid_float?(float),
    do: {:error, :not_number}

  def encode_xdr(%XDR.Float{float: float}), do: {:ok, <<float::big-signed-float-size(32)>>}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.Float` structure into a XDR format.
  If the `float` is not valid, an exception is raised.
  """
  @spec encode_xdr!(float :: t) :: binary
  def encode_xdr!(float) do
    case encode_xdr(float) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(FloatError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Floating-Point in XDR format to a `XDR.Float` structure.
  """
  @spec decode_xdr(bytes :: binary, float :: t) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, float \\ nil)

  def decode_xdr(bytes, _float) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(<<float::big-signed-float-size(32), rest::binary>>, _float),
    do: {:ok, {new(float), rest}}

  @impl XDR.Declaration
  @doc """
  Decode the Floating-Point in XDR format to a `XDR.Float` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary, float :: t) :: {t, binary}
  def decode_xdr!(bytes, float \\ nil)

  def decode_xdr!(bytes, float) do
    case decode_xdr(bytes, float) do
      {:ok, result} -> result
      {:error, reason} -> raise(FloatError, reason)
    end
  end
end
