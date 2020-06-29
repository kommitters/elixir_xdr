defmodule XDR.HyperInt do
  @moduledoc """
  This module manages the `Hyper Integer` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.HyperInt, as: HyperIntError

  defstruct [:datum]

  @typedoc """
  `XDR.HyperInt` structure type specification.
  """
  @type t :: %XDR.HyperInt{datum: integer | binary}

  @doc """
  Create a new `XDR.HyperInt` structure with the `datum` passed.
  """
  @spec new(datum :: integer | binary) :: t
  def new(datum), do: %XDR.HyperInt{datum: datum}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.HyperInt` structure into a XDR format.
  """
  @spec encode_xdr(h_int :: t) ::
          {:ok, binary} | {:error, :not_integer | :exceed_upper_limit | :exceed_lower_limit}
  def encode_xdr(%XDR.HyperInt{datum: datum}) when not is_integer(datum),
    do: {:error, :not_integer}

  def encode_xdr(%XDR.HyperInt{datum: datum}) when datum > 9_223_372_036_854_775_807,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.HyperInt{datum: datum}) when datum < -9_223_372_036_854_775_808,
    do: {:error, :exceed_lower_limit}

  def encode_xdr(%XDR.HyperInt{datum: datum}), do: {:ok, <<datum::big-signed-integer-size(64)>>}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.HyperInt` structure into a XDR format.
  If the `h_int` is not valid, an exception is raised.
  """
  @spec encode_xdr!(h_int :: t) :: binary
  def encode_xdr!(h_int) do
    case encode_xdr(h_int) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(HyperIntError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Hyper Integer in XDR format to a `XDR.HyperInt` structure.
  """
  @spec decode_xdr(bytes :: binary, h_int :: t) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, h_int \\ nil)

  def decode_xdr(bytes, _h_int) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(<<hyper_int::big-signed-integer-size(64), rest::binary>>, _h_int),
    do: {:ok, {new(hyper_int), rest}}

  @impl XDR.Declaration
  @doc """
  Decode the Hyper Integer in XDR format to a `XDR.HyperInt` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary, h_int :: t) :: {t, binary}
  def decode_xdr!(bytes, h_int \\ nil)

  def decode_xdr!(bytes, h_int) do
    case decode_xdr(bytes, h_int) do
      {:ok, result} -> result
      {:error, reason} -> raise(HyperIntError, reason)
    end
  end
end
