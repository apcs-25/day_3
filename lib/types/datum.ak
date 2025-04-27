use aiken/cbor
use aiken/crypto.{VerificationKeyHash}

pub type MyDatum {
  beneficiary: VerificationKeyHash,
  deadline: Int,
}

/// d8799f4a4a6f686e20536d6974681904d2ff - ts
/// D8799F4A4A6F686E20536D6974681904D2FF - ak
test my_datum() {
  let my_datum =
    MyDatum { beneficiary: #"abcd", deadline: 1234 } |> cbor.serialise
  trace my_datum
  my_datum == #"d8799f42abcd1904d2ff"
}

pub type MultiConstructors {
  Constr1
  Constr2(Int)
  Constr3 { field1: ByteArray, field2: Bool }
}

/// multi_constructors:
/// - c1 = D87980
/// - c2 = D87A9F0AFF
/// - c3 = D87B9F46616263646566D87A80FF
test multi_constructors() {
  let c1 = Constr1 |> cbor.serialise
  let c2 = Constr2(10) |> cbor.serialise
  let c3 = Constr3 { field1: "abcdef", field2: True } |> cbor.serialise
  trace @"MultiConstructors": c1, c2, c3
  True
}
