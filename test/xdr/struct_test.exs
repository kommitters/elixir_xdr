defmodule XDR.StructTest do
  use ExUnit.Case

  alias TestFile
  alias XDR.Struct
  alias XDR.Error.Struct, as: StructErr

  describe "Encoding Struct to binary" do
    test "when is not a list" do
      try do
        # This keyword must be created based on a structure, you can see the Structure example at the end of the file
        component_keyword = TestFile.new("The Little Prince", 200) |> Map.from_struct()

        component_keyword
        |> Struct.new()
        |> Struct.encode_xdr()
      rescue
        error ->
          assert error == %StructErr{
                   message: "The :components received by parameter must be a keyword list"
                 }
      end
    end

    test "when is an empty list" do
      try do
        Struct.new([])
        |> Struct.encode_xdr()
      rescue
        error ->
          assert error == %StructErr{
                   message: "The :components must not be empty, it must be a keyword list"
                 }
      end
    end

    test "with valid data" do
      component_keyword =
        TestFile.new("The Little Prince", 200) |> Map.from_struct() |> Map.to_list()

      {status, result} =
        component_keyword
        |> Struct.new()
        |> Struct.encode_xdr()

      assert status == :ok

      assert result ==
               <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105,
                 110, 99, 101, 0, 0, 0, 0, 0, 0, 200>>
    end

    test "decode_xdr! with valid Struct" do
      component_keyword =
        TestFile.new("The Little Prince", 200) |> Map.from_struct() |> Map.to_list()

      result =
        component_keyword
        |> Struct.new()
        |> Struct.encode_xdr!()

      assert result ==
               <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105,
                 110, 99, 101, 0, 0, 0, 0, 0, 0, 200>>
    end
  end

  describe "Decoding binary to integer" do
    test "when is not a binary value" do
      try do
        component_keyword = Map.from_struct(TestFile.__struct__()) |> Map.to_list()

        Struct.new(component_keyword, [0, 0, 2, 0, 3, 0, 1, 0])
        |> Struct.decode_xdr()
      rescue
        error ->
          assert error == %StructErr{
                   message:
                     "The :struct received by parameter must be a binary value, for example: <<0, 0, 0, 5>>"
                 }
      end
    end

    test "when is a valid binary" do
      component_keyword = TestFile.__struct__() |> Map.from_struct() |> Map.to_list()

      {status, result} =
        component_keyword
        |> Struct.new(
          <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105, 110, 99,
            101, 0, 0, 0, 0, 0, 0, 200>>
        )
        |> Struct.decode_xdr()

      assert status == :ok

      assert result == {[file_name: "The Little Prince", file_size: 200], ""}
    end

    test "decode_xdr! with valid binary" do
      component_keyword = TestFile.__struct__() |> Map.from_struct() |> Map.to_list()

      result =
        component_keyword
        |> Struct.new(
          <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105, 110, 99,
            101, 0, 0, 0, 0, 0, 0, 200>>
        )
        |> Struct.decode_xdr!()

      assert result === {[file_name: "The Little Prince", file_size: 200], ""}
    end

    test "with valid data, with extra bytes" do
      component_keyword = TestFile.__struct__() |> Map.from_struct() |> Map.to_list()

      {status, result} =
        component_keyword
        |> Struct.new(
          <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105, 110, 99,
            101, 0, 0, 0, 0, 0, 0, 200, 0, 0, 2, 1>>
        )
        |> Struct.decode_xdr()

      assert status == :ok

      assert result == {[file_name: "The Little Prince", file_size: 200], <<0, 0, 2, 1>>}
    end
  end

  describe "Testing an example structure" do
    test "encode TestFile" do
      {status, result} =
        TestFile.new("The Little Prince", 200)
        |> TestFile.encode_xdr()

      assert status == :ok

      assert result ==
               <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105,
                 110, 99, 101, 0, 0, 0, 0, 0, 0, 200>>
    end

    test "decode TestFile" do
      {status, result} =
        TestFile.decode_xdr(
          <<0, 0, 0, 17, 84, 104, 101, 32, 76, 105, 116, 116, 108, 101, 32, 80, 114, 105, 110, 99,
            101, 0, 0, 0, 0, 0, 0, 200>>
        )

      assert status == :ok

      assert result == {TestFile.new("The Little Prince", 200), ""}
    end
  end
end

defmodule TestFile do
  @behaviour XDR.Declaration

  defstruct file_name: XDR.String, file_size: XDR.Int

  @type t :: %TestFile{file_name: XDR.String.t(), file_size: XDR.Int.t()}

  def new(file_name, file_size) do
    %TestFile{file_name: file_name |> XDR.String.new(), file_size: file_size |> XDR.Int.new()}
  end

  @impl XDR.Declaration
  def encode_xdr(test_file) do
    component_keyword = test_file |> Map.from_struct() |> Map.to_list()

    XDR.Struct.new(component_keyword)
    |> XDR.Struct.encode_xdr()
  end

  @impl XDR.Declaration
  def encode_xdr!(struct), do: encode_xdr(struct) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(binary) do
    component_keyword = TestFile.__struct__() |> Map.from_struct() |> Map.to_list()

    XDR.Struct.new(component_keyword, binary)
    |> XDR.Struct.decode_xdr!()
    |> perform_struct()
  end

  @impl XDR.Declaration
  def decode_xdr!(struct), do: decode_xdr(struct) |> elem(1)

  defp perform_struct({components, rest}) do
    struct = TestFile.new(components[:file_name], components[:file_size])

    {:ok, {struct, rest}}
  end
end
