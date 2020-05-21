defmodule XDR.UnionTest do
  use ExUnit.Case

  alias XDR.Union
  alias XDR.Error.Union, as: UnionErr

  describe "new" do
    test "with Enum" do
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: :SCP_ST_NOMINATE
      }

      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      Union.new(enum, arms)
    end
  end

  describe "Encoding discriminated union" do
    test "when receives an invalid identifier" do
      # Enum structure with invalid identifier
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: "SCP_ST_EXTERNALIZE"
      }

      # Valid arms for the union encode
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      {status, reason} = Union.encode_xdr(%{discriminant: enum, arms: arms})

      assert status == :error
      assert reason == :not_atom
    end

    test "Enum example" do
      {status, result} =
        UnionSCPStatementType.new(:SCP_ST_PREPARE)
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "encode_xdr! Enum example" do
      result =
        UnionSCPStatementType.new(:SCP_ST_PREPARE)
        # It also can use the XDR.UnionEnum.decode_xdr()/1 function
        |> Union.encode_xdr!()

      assert result == <<0, 0, 0, 0, 0, 0, 0, 60>>
    end

    test "encode_xdr! when receives an invalid identifier" do
      enum = %{
        declarations: [
          SCP_ST_PREPARE: 0,
          SCP_ST_CONFIRM: 1,
          SCP_ST_EXTERNALIZE: 2,
          SCP_ST_NOMINATE: 3
        ],
        identifier: "SCP_ST_EXTERNALIZE"
      }

      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      assert_raise UnionErr, fn -> Union.encode_xdr!(%{discriminant: enum, arms: arms}) end
    end

    test "Uint example" do
      {status, result} =
        UnionNumber.new(3)
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> UnionNumber.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end

    test "encode_xdr! Uint example" do
      result =
        UnionNumber.new(3)
        # It also can use the XDR.UnionNumber.decode_xdr()/1 function
        |> UnionNumber.encode_xdr!()

      assert result == <<0, 0, 0, 3, 64, 93, 112, 164>>
    end
  end

  describe "Decoding Discriminated Union" do
    test "when receives an invalid identifier" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      {status, reason} =
        Union.decode_xdr([0, 0, 0, 0, 0, 0, 0, 0], %{
          discriminant: %{declarations: nil, identifier: nil},
          arms: arms
        })

      assert status == :error
      assert reason == :not_binary
    end

    test "when receives an invalid declarations" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      {status, reason} =
        Union.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 0>>, %{
          discriminant: %{declarations: nil},
          arms: arms
        })

      assert status == :error
      assert reason == :not_list
    end

    test "when receives an invalid binary" do
      arms = %{
        0 => XDR.Int.new(60),
        1 => XDR.String.new("Confirm"),
        2 => XDR.Bool.new(false),
        3 => XDR.Float.new(3.46)
      }

      {status, reason} =
        Union.decode_xdr([0, 0, 0, 3, 64, 93, 112, 164], %{
          discriminant: XDR.UInt.new(nil),
          arms: arms,
          struct: %{discriminant: XDR.UInt}
        })

      assert status == :error
      assert reason == :not_binary
    end

    test "Enum example" do
      # It also can use the XDR.UnionEnum.decode_xdr()/1 function
      {status, result} = UnionSCPStatementType.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert status == :ok
      assert result == {{:SCP_ST_PREPARE, %XDR.Int{datum: 60}}, ""}
    end

    test "decode_xdr! with Enum example" do
      # It also can use the XDR.UnionEnum.decode_xdr()/1 function
      result = UnionSCPStatementType.decode_xdr!(<<0, 0, 0, 0, 0, 0, 0, 60>>)

      assert result == {{:SCP_ST_PREPARE, %XDR.Int{datum: 60}}, ""}
    end

    test "Uint example" do
      # It also can use the XDR.UnionNumber.decode_xdr()/1 function
      {status, result} = UnionNumber.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)

      assert status == :ok
      assert result == {{3, %XDR.Float{float: 3.4600000381469727}}, ""}
    end

    test "decode_xdr! with Uint Example" do
      result = UnionNumber.decode_xdr!(<<0, 0, 0, 3, 64, 93, 112, 164>>)

      assert result == {{3, %XDR.Float{float: 3.4600000381469727}}, ""}
    end

    test "decode_xdr! when receives an invalid identifier" do
      arms = [
        SCP_ST_PREPARE: XDR.Int.new(60),
        SCP_ST_CONFIRM: XDR.String.new("Confirm"),
        SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
        SCP_ST_NOMINATE: XDR.Float.new(3.46)
      ]

      enum = %{
        discriminant: %{declarations: nil, identifier: nil},
        arms: arms
      }

      assert_raise UnionErr, fn -> Union.decode_xdr!([0, 0, 0, 0, 0, 0, 0, 0], enum) end
    end
  end
end

defmodule UnionSCPStatementType do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.Enum, arms: nil, struct: nil

  @arms [
    SCP_ST_PREPARE: XDR.Int.new(60),
    SCP_ST_CONFIRM: XDR.String.new("Confirm"),
    SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
    SCP_ST_NOMINATE: XDR.Float.new(3.46)
  ]

  def new(identifier),
    do: %UnionSCPStatementType{
      discriminant: SCPStatementType.new(identifier),
      arms: @arms,
      struct: %{discriminant: XDR.Enum}
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionSCPStatementType{} = union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(%UnionSCPStatementType{} = union), do: encode_xdr(union) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionSCPStatementType{} = union), do: XDR.Union.decode_xdr(bytes, union)

  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))

  def decode_xdr!(bytes, %UnionSCPStatementType{} = union),
    do: XDR.Union.decode_xdr!(bytes, union)
end

defmodule UnionNumber do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.UInt, arms: nil, struct: nil

  @arms %{
    0 => XDR.Int.new(60),
    1 => XDR.String.new("Confirm"),
    2 => XDR.Bool.new(false),
    3 => XDR.Float.new(3.46)
  }

  def new(identifier),
    do: %UnionNumber{
      discriminant: XDR.UInt.new(identifier),
      arms: @arms,
      struct: %{discriminant: XDR.UInt}
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionNumber{} = union), do: XDR.Union.encode_xdr(union)
  @impl XDR.Declaration
  def encode_xdr!(%UnionNumber{} = union), do: XDR.Union.encode_xdr!(union)
  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr(bytes, union)
  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr!(bytes, union)
end

defmodule SCPStatementType do
  @behaviour XDR.Declaration

  defstruct declarations: nil, identifier: nil

  @scp_statement_type [
    SCP_ST_PREPARE: 0,
    SCP_ST_CONFIRM: 1,
    SCP_ST_EXTERNALIZE: 2,
    SCP_ST_NOMINATE: 3
  ]

  def new(identifier),
    do: %SCPStatementType{declarations: @scp_statement_type, identifier: identifier}

  @impl XDR.Declaration
  defdelegate encode_xdr(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate encode_xdr!(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr(bytes, struct), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr!(bytes, struct), to: XDR.Enum
end
