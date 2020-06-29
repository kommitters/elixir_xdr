defmodule XDR.UInt do
  @moduledoc """
  This module manages the `Unsigned Integer` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.UInt, as: UIntError

  defstruct [:datum]

  @typedoc """
  `XDR.UInt` structure type specification.
  """
  @type t :: %XDR.UInt{datum: integer() | binary()}

  @doc """
  Create a new `XDR.UInt` structure with the `datum` passed.
  """
  @spec new(datum :: integer()) :: t
  def new(datum), do: %XDR.UInt{datum: datum}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.UInt` structure into a XDR format.
  """
  @spec encode_xdr(u_int :: t) ::
          {:ok, binary()} | {:error, :not_integer | :exceed_upper_limit | :exceed_lower_limit}
  def encode_xdr(%XDR.UInt{datum: datum}) when not is_integer(datum), do: {:error, :not_integer}

  def encode_xdr(%XDR.UInt{datum: datum}) when datum > 4_294_967_295,
    do: {:error, :exceed_upper_limit}

  def encode_xdr(%XDR.UInt{datum: datum}) when datum < 0, do: {:error, :exceed_lower_limit}
  def encode_xdr(%XDR.UInt{datum: datum}), do: {:ok, <<datum::big-unsigned-integer-size(32)>>}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.UInt` structure into a XDR format.
  If the `u_int` is not valid, an exception is raised.
  """
  @spec encode_xdr!(u_int :: t) :: binary()
  def encode_xdr!(u_int) do
    case encode_xdr(u_int) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(UIntError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Unsigned Integer in XDR format to a `XDR.UInt` structure.
  """
  @spec decode_xdr(bytes :: binary(), u_int :: t) :: {:ok, {t, binary}} | {:error, :not_binary}
  def decode_xdr(bytes, u_int \\ nil)
  def decode_xdr(bytes, _u_int) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(<<datum::big-unsigned-integer-size(32), rest::binary>>, _u_int),
    do: {:ok, {new(datum), rest}}

  @impl XDR.Declaration
  @doc """
  Decode the Unsigned Integer in XDR format to a `XDR.UInt` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), u_int :: t) :: {t, binary}
  def decode_xdr!(bytes, u_int \\ nil)

  def decode_xdr!(bytes, _u_int) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(UIntError, reason)
    end
  end
end
