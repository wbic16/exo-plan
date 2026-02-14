//! vTPU Runtime: Software-Defined Virtual TPU with Phext-Native Addressing
//!
//! This crate implements the vTPU architecture specified in R23W1.
//! Core innovation: 3-pipe retirement model (D/S/C) achieves 3 ops/cycle
//! on commodity AMD Zen 4 processors via sentron-native instruction scheduling.

pub mod siw;
pub mod pipes;
pub mod phext_coord;
pub mod telemetry;
pub mod scheduler;

pub use siw::SIW;
pub use pipes::{DenseOp, SparseOp, CoordOp};
pub use phext_coord::PhextCoord;
pub use telemetry::VtpuTelemetry;
