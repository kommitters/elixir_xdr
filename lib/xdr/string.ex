defmodule XDR.String do
  @moduledoc """
  this module is in charge of process the  String types based on the RFC4506 XDR Standard
  """

  @behaviour XDR.Declaration

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
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.String{string: string}) when not is_bitstring(string),
    do: raise(StringErr, :not_bitstring)

  def encode_xdr(%XDR.String{string: string}) do
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
  @spec encode_xdr!(t()) :: binary
  def encode_xdr!(string), do: encode_xdr(string) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string, it receives and XDR.String structure which contains the binary to encode

  returns an :ok tuple with the resulted string
  """
  @spec decode_xdr(t()) :: {:ok, {String.t(), binary()}}
  def decode_xdr(%XDR.String{string: string, max_length: max_length}) do
    {binary, rest} =
      VariableOpaque.new(string, max_length)
      |> VariableOpaque.decode_xdr!()

    decoded_string =
      binary
      |> String.graphemes()
      |> Enum.join("")

    {:ok, {decoded_string, rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string, it receives and XDR.String structure which contains the binary to encode

  returns the resulted string
  """
  @spec decode_xdr!(t()) :: {String.t(), binary()}
  def decode_xdr!(string), do: decode_xdr(string) |> elem(1)
end
