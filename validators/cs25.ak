use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/interval.{Finite}
use aiken/option
use cardano/transaction.{OutputReference, Transaction}
use types/datum.{MyDatum}

validator day_3(admin: VerificationKeyHash) {
  spend(
    datum: Option<Data>,
    _redeemer: Data,
    _o_ref: OutputReference,
    tx: Transaction,
  ) {
    // AND:
    // 1. Must be signed by beneficiary
    // 2. Must be performed after the deadline
    expect Finite(now) = tx.validity_range.lower_bound.bound_type
    let my_datum: Data =
      // Piping (|>): https://aiken-lang.org/language-tour/control-flow#piping
      datum
        |> option.or_else(
            {
              // Block ({ .. }): https://aiken-lang.org/language-tour/control-flow#blocks
              let dt: Data = MyDatum { beneficiary: admin, deadline: now }
              dt
            },
          )

    if my_datum is md: MyDatum {
      and {
        (tx.extra_signatories |> list.has(md.beneficiary))?,
        (now >= md.deadline)?,
      }
    } else {
      True
    }
  }

  else(_) {
    fail
  }
}

test day_3_spend() {
  let admin = "0"
  let beneficiary = "1"
  let now = 1745078035000

  let datum = MyDatum { beneficiary, deadline: now }
  let redeemer = 0

  let o_ref = OutputReference("", 0)

  let tx =
    Transaction {
      ..transaction.placeholder,
      validity_range: interval.between(now, now + 15 * 60_000),
      extra_signatories: [beneficiary],
    }

  day_3.spend(
    admin,
    Some(
      {
        // Block: https://aiken-lang.org/language-tour/control-flow#blocks
        let data: Data = datum
        data
      },
    ),
    redeemer,
    o_ref,
    tx,
  )
}
