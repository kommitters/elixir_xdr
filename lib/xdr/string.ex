defmodule XDR.String do
  @moduledoc """
  This module manages the `String` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.VariableOpaque
  alias XDR.Error.String, as: StringError

  defstruct [:string, :max_length]

  @typedoc """
  `XDR.String` structure type specification.
  """
  @type t :: %XDR.String{string: binary(), max_length: integer()}

  @doc """
  Create a new `XDR.String` structure with the `opaque` and `length` passed.
  """
  @spec new(string :: bitstring(), max_length :: integer()) :: t()
  def new(string, max_length \\ 4_294_967_295)
  def new(string, max_length), do: %XDR.String{string: string, max_length: max_length}

  @doc """
  Encode a `XDR.String` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{string: string}) when not is_bitstring(string),
    do: {:error, :not_bitstring}

  def encode_xdr(%{string: string, max_length: max_length}) when byte_size(string) > max_length,
    do: {:error, :invalid_length}

  def encode_xdr(%{string: string, max_length: max_length}) do
    variable_opaque =
      string
      |> VariableOpaque.new(max_length)
      |> VariableOpaque.encode_xdr!()

    {:ok, variable_opaque}
  end

  @doc """
  Encode a `XDR.String` structure into a XDR format.
  If the `string` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(string) do
    case encode_xdr(string) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(StringError, reason)
    end
  end

  @doc """
  Decode the String in XDR format to a `XDR.String` structure.
  """
  @impl true
  def decode_xdr(bytes, string \\ %{max_length: 4_294_967_295})
  def decode_xdr(bytes, _string) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, %{max_length: max_length}) do
    variable_struct = VariableOpaque.new(nil, max_length)

    {binary, rest} = VariableOpaque.decode_xdr!(bytes, variable_struct)

    decoded_string =
      binary
      |> Map.get(:opaque)
      |> String.graphemes()
      |> Enum.join("")
      |> new(max_length)

    {:ok, {decoded_string, rest}}
  end

  @doc """
  Decode the String in XDR format to a `XDR.String` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, string \\ %{max_length: 4_294_967_295})

  def decode_xdr!(bytes, string) do
    case decode_xdr(bytes, string) do
      {:ok, result} -> result
      {:error, reason} -> raise(StringError, reason)
    end
  end
end
