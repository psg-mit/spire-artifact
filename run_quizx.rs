use std::env;

use quizx::circuit::*;
use quizx::vec_graph::*;
use quizx::simplify::*;
use quizx::extract::*;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    let c = Circuit::from_file(&args[1])?;
    let c0 = c.to_basic_gates();
    eprintln!("Before:\n{}", c0.stats());
    let mut g: Graph = c.to_graph();
    full_simp(&mut g);
    eprintln!("simplified ok");
    match g.to_circuit() {
        Ok(c1) => {
            eprintln!("extracted ok");
            eprintln!("After:\n{}", c1.stats());
            println!("{}", c1.to_qasm());
        },
        Err(ExtractError(msg, _c, _g)) => {
            eprintln!("extract failed: {}", msg);
            eprintln!("After:\n{}", _c.stats());
        },
    }
    Ok(())
}
