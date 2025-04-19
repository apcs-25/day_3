//// Module document

use aiken/collection/list

pub type OurBool {
  OurFalse
  OurTrue
}

fn backpassing() {
  let n <- list.all([])

  let zero = 0
  n > zero
}

test backp() {
  backpassing()
}
