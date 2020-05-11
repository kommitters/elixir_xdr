defmodule XDR.Typedef do
  @behaviour XDR.Declaration
  @moduledoc """
  this module is in charge of process the typedef declarations on XDR format
  """

  defstruct declaration: nil, name: nil, params: nil

  ##
  # TO-DO: Añadir caracteristicas a la implementación esta puede ser una constante y no es obligatoria
  # see -> https://docs.oracle.com/cd/E23824_01/html/821-1671/xdrproto-31244.html
  # or -> https://pubs.opengroup.org/onlinepubs/9629799/chap3.htm
  # good look,you are the best
  ##


  @type t :: %XDR.Typedef{declaration: any(), name: String, params: nil | XDR.Const}

  @doc """
  this function provides an easy way to create a new typedef
  """
  @spec new(declaration :: any, name :: String.t(), params :: XDR.Const | nil) :: t()
  def new(_declaration, name, params \\ nil)
  def new(_declaration, name, _params) when not is_bitstring(name), do: {:error, :invalid}
  def new(declaration, name, params), do: %XDR.Typedef{declaration: declaration, name: name, params: params}

  @doc """
  this function is in charge of encode a new typedef into a binary, it receives a XDR.Typedef struct which contains
  the name of the new type and the type.

  returns an :ok tuple which contains the resulted XDR
  """
  # When not receive an extra parameter run the following function
  def encode_xdr(%XDR.Typedef{declaration: declaration, name: name, params: params}) when is_nil(params) do
    declaration_type= declaration.__struct__
    binary_declaration = declaration_type.encode_xdr!(declaration)

    binary_name =
      XDR.String.new(name)
      |> XDR.String.encode_xdr!()

    {:ok, binary_declaration <> binary_name}
  end

  # When receives an extra parameter to the declaration
  def encode_xdr(%XDR.Typedef{declaration: declaration, name: name, params: params}) do
    declaration_type= declaration.__struct__
    binary_declaration = declaration_type.encode_xdr!(declaration)

    binary_name =
      XDR.String.new(name)
      |> XDR.String.encode_xdr!()

    binary_params =
      declaration.__struct__.encode(params)


    {:ok, binary_declaration <> binary_name <> binary_params}
  end

  @doc """
  this function is in charge of encode a new typedef into a binary, it receives a XDR.Typedef struct which contains
  the name of the new type and the type.

  returns the resulted XDR
  """
  def encode_xdr!(%XDR.Typedef{} = type_def), do: encode_xdr(type_def) |> elem(1)

  @doc """
  this function is in charge of decode the typedef binaries into an typedef struct, it receives a XDR.Typedef structure which
  contains the data needed to decode the binary, type_def represents the binary which contains the data to decode, and struct
  represents the structure to which it belongs

  returns an :ok tuple with the resulted typedef
  """
  def decode_xdr(%{type_def: binary, struct: %{declaration: declaration, params: params}}) do
    declaration_module = declaration.__struct__
    {decoded_declaration, declaration_rest} =
    declaration_module.new(binary)
    |> declaration_module.decode_xdr!()

    {decoded_name, name_rest} =
      XDR.String.new(declaration_rest)
      |> XDR.String.decode_xdr!()

    params_module = params.__struct__
    {decoded_params, rest} =
      params_module.new(name_rest)
      |> params_module.decode_xdr!()

    {:ok, new(decoded_declaration, decoded_name, decoded_params), rest}
  end

  def decode_xdr(%{type_def: binary, struct: %{declaration: declaration}}) do
    declaration_module = declaration.__struct__
    {decoded_declaration, declaration_rest} =
    declaration_module.new(binary)
    |> declaration_module.decode_xdr!()

    {decoded_name, rest} =
      XDR.String.new(declaration_rest)
      |> XDR.String.decode_xdr!()

    {:ok, new(decoded_declaration, decoded_name), rest}
  end

  def decode_xdr!(type_def), do: decode_xdr(type_def) |> elem(1)
end
