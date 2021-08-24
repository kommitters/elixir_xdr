defmodule XDR.Void do
  @moduledoc """
  This module manages the `Void` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Void, as: VoidError

  defstruct [:void]

  @typedoc """
  `XDR.Void` struct type specification.
  """
  @type t :: %XDR.Void{void: nil}

  @doc """
  Create a new `XDR.Void` structure from the `value` passed.
  """
  @spec new(value :: nil) :: t
  def new(value \\ nil) when is_nil(value), do: %XDR.Void{}

  @doc """
  Encode a `XDR.Void` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%XDR.Void{void: nil}), do: {:ok, <<>>}
  def encode_xdr(_), do: {:error, :not_void}

  @doc """
  Encode a `XDR.Void` structure into a XDR format.
  If the structure received is not `XDR.Void`, an exception is raised.
  """
  @impl true
  def encode_xdr!(void) do
    case encode_xdr(void) do
      {:ok, result} -> result
      {:error, reason} -> raise(VoidError, reason)
    end
  end

  @doc """
  Decode the XDR format to a void format.
  """
  @impl true
  def decode_xdr(bytes, _void \\ nil)
  def decode_xdr(<<rest::binary>>, _), do: {:ok, {nil, rest}}
  def decode_xdr(_, _), do: {:error, :not_binary}

  @doc """
  Decode the XDR format to a void format.
  If the binary is not a valid void, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, _void \\ nil) do
    case decode_xdr(bytes) do
      {:ok, result} -> result
      {:error, reason} -> raise(VoidError, reason)
    end
  end
end
