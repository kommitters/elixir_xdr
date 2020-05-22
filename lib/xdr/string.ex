defmodule XDR.String do
  @behaviour XDR.Declaration
  @moduledoc """
  this module is in charge of process the  String types based on the RFC4506 XDR Standard
  """

  defstruct string: nil, max_length: nil

  @typedoc """
  Every String structure has a String which represent the value which you try to encode
  """
  @type t :: %XDR.String{string: String.t() | binary(), max_length: integer}

  alias XDR.VariableOpaque
  alias XDR.Error.String, as: StringErr

  @doc """
  this function provides an easy way to create an XDR.String type

  returns a XDR.String struct with the value received as parameter
  """
  @spec new(string :: bitstring(), max_length :: integer()) :: t()
  def new(string, max_length \\ 4_294_967_295)
  def new(string, max_length), do: %XDR.String{string: string, max_length: max_length}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode an string into an XDR format,it receives an XDR.String which contains the value to encode

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(map()) :: {:ok, binary} | {:error, :not_bitstring}
  def encode_xdr(%{string: string}) when not is_bitstring(string),
    do: {:error, :not_bitstring}

  def encode_xdr(%{string: string}) do
    length = byte_size(string)

    variable_opaque =
      VariableOpaque.new(string, length)
      |> VariableOpaque.encode_xdr!()

    {:ok, variable_opaque}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode an string into an XDR format,it receives an XDR.String which contains the value to encode

  returns the resulted XDR
  """
  @spec encode_xdr!(map()) :: binary
  def encode_xdr!(string) do
    case encode_xdr(string) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(StringErr, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string, it receives and XDR.String structure which contains the binary to encode

  returns an :ok tuple with the resulted string
  """
  @spec decode_xdr(bytes :: binary, struct :: map() | any) ::
          {:ok, {t(), binary()}} | {:error, :not_binary}
  def decode_xdr(bytes, struct \\ %{max_length: 4_294_967_295})
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :not_binary}

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

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string, it receives and XDR.String structure which contains the binary to encode

  returns the resulted string
  """
  @spec decode_xdr!(bytes :: binary, struct :: map() | any) :: {t(), binary()}
  def decode_xdr!(bytes, struct \\ %{max_length: 4_294_967_295})

  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(StringErr, reason)
    end
  end
end
