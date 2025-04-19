use aiken/crypto.{VerificationKeyHash}

pub type MyDatum {
  beneficiary: VerificationKeyHash,
  deadline: Int,
}
