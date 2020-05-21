defmodule XDR.VariableOpaqueTest do
  use ExUnit.Case

  alias XDR.VariableOpaque
  alias XDR.Error.VariableOpaque, as: VariableOpaqueErr

  describe "Encoding Variable Opaque" do
    test "when xdr is not binary" do
      {status, reason} =
        VariableOpaque.new([0, 0, 1], 2)
        |> VariableOpaque.encode_xdr()

      assert status == :error
      assert reason == :not_binary
    end

    test "with invalid length" do
      {status, reason} =
        VariableOpaque.new(<<0, 0, 1>>, 2)
        |> VariableOpaque.encode_xdr()

      assert status == :error
      assert reason == :invalid_length
    end

    test "when length is not an integer" do
      {status, reason} =
        VariableOpaque.new(<<0, 0, 1>>, "hi")
        |> VariableOpaque.encode_xdr()

      assert status == :error
      assert reason == :not_number
    end

    test "when exceed lower bound" do
      {status, reason} =
        VariableOpaque.new(<<0, 0, 1>>, -1)
        |> VariableOpaque.encode_xdr()

      assert status == :error
      assert reason == :exceed_lower_bound
    end

    test "when exceed upper bound" do
      {status, reason} =
        VariableOpaque.new(<<0, 0, 1>>, 4_294_967_296)
        |> VariableOpaque.encode_xdr()

      assert status == :error
      assert reason == :exceed_upper_bound
    end

    test "with valid data" do
      {status, result} =
        VariableOpaque.new(<<0, 0, 1>>)
        |> VariableOpaque.encode_xdr()

      assert status == :ok
      assert result == <<0, 0, 0, 3, 0, 0, 1, 0>>
    end

    test "encode_xdr! with valid data" do
      result =
        VariableOpaque.new(<<0, 0, 1>>)
        |> VariableOpaque.encode_xdr!()

      assert result == <<0, 0, 0, 3, 0, 0, 1, 0>>
    end

    test "encode_xdr! when xdr is not binary" do
      variable_opaque = VariableOpaque.new([0, 0, 1], 2)

      assert_raise VariableOpaqueErr, fn -> VariableOpaque.encode_xdr!(variable_opaque) end
    end
  end

  describe "Decoding Variable Opaque" do
    test "when xdr is not binary" do
      {status, reason} = VariableOpaque.decode_xdr([0, 0, 1], %XDR.VariableOpaque{max_size: 2})

      assert status == :error
      assert reason == :not_binary
    end

    test "when length is not an integer" do
      {status, reason} =
        VariableOpaque.decode_xdr(<<0, 0, 1, 0>>, %XDR.VariableOpaque{max_size: "2"})

      assert status == :error
      assert reason == :not_number
    end

    test "when exceed lower bound" do
      {status, reason} = VariableOpaque.decode_xdr(<<0, 0, 1>>, %XDR.VariableOpaque{max_size: -1})

      assert status == :error
      assert reason == :exceed_lower_bound
    end

    test "when exceed upper bound" do
      {status, reason} =
        VariableOpaque.decode_xdr(<<0, 0, 1>>, %XDR.VariableOpaque{max_size: 4_294_967_296})

      assert status == :error
      assert reason == :exceed_upper_bound
    end

    test "when the length is bigger than the defined max" do
      {status, reason} =
        VariableOpaque.decode_xdr(<<0, 0, 0, 6>>, %XDR.VariableOpaque{max_size: 1})

      assert status == :error
      assert reason == :length_over_max
    end

    test "when the length is bigger than the rest binaries" do
      {status, reason} = VariableOpaque.decode_xdr(<<0, 0, 0, 6, 0, 0, 0, 0>>)

      assert status == :error
      assert reason == :length_over_rest
    end

    test "with valid data" do
      {status, result} = VariableOpaque.decode_xdr(<<0, 0, 0, 2, 0, 1, 0, 0>>)

      assert status == :ok
      assert result == {%XDR.VariableOpaque{max_size: 4_294_967_295, opaque: <<0, 1>>}, <<>>}
    end

    test "decode_xdr! with valid data" do
      result = VariableOpaque.decode_xdr!(<<0, 0, 0, 2, 0, 1, 0, 0>>)

      assert result == {%XDR.VariableOpaque{max_size: 4_294_967_295, opaque: <<0, 1>>}, <<>>}
    end

    test "decode_xdr! when xdr is not binary" do
      assert_raise VariableOpaqueErr, fn ->
        VariableOpaque.decode_xdr!([0, 0, 1], %XDR.VariableOpaque{max_size: 2})
      end
    end
  end
end
