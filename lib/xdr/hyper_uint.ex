defmodule XDR.HyperUInt do
  @moduledoc """
  This module manages the `Unsigned Hyper Integer` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.HyperUInt, as: HyperUIntError

  defstruct [:datum]

  @type datum :: integer() | binary()

  @typedoc """
  `XDR.HyperUInt` structure type specification.
  """
  @type t :: %XDR.HyperUInt{datum: datum()}

  @doc """
  Create a new `XDR.HyperUInt` structure with the `opaque` and `length` passed.
  """
  @spec new(datum :: datum()) :: t()
  def new(datum), do: %XDR.HyperUInt{datum: datum}

  @doc """
  Encode a `XDR.HyperUInt` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%XDR.HyperUInt{datum: datum}) when not is_integer(datum),
    do: {:error, :not_integer}

  def encode_xdr(%XDR.HyperUInt{datum: datum}) when datum > 18_446_744_073_709_551_615,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.HyperUInt{datum: datum}) when datum < 0,
    do: {:error, :exceed_lower_limit}

  def encode_xdr(%XDR.HyperUInt{datum: datum}),
    do: {:ok, <<datum::big-unsigned-integer-size(64)>>}

  @doc """
  Encode a `XDR.HyperUInt` structure into a XDR format.
  If the `h_uint` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(h_uint) do
    case encode_xdr(h_uint) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(HyperUIntError, reason)
    end
  end

  @doc """
  Decode the Unsigned Hyper Integer in XDR format to a `XDR.HyperUInt` structure.
  """
  @impl true
  def decode_xdr(bytes, h_uint \\ nil)

  def decode_xdr(bytes, _h_uint) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(<<hyper_uint::big-unsigned-integer-size(64), rest::binary>>, _h_uint),
    do: {:ok, {new(hyper_uint), rest}}

  @doc """
  Decode the Unsigned Hyper Integer in XDR format to a `XDR.HyperUInt` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, h_uint \\ nil)

  def decode_xdr!(bytes, h_uint) do
    case decode_xdr(bytes, h_uint) do
      {:ok, result} -> result
      {:error, reason} -> raise(HyperUIntError, reason)
    end
  end
end
