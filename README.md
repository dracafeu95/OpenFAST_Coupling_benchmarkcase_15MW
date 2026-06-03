# Benchmarking case for Aero-servo-elastic LES codes

## Benchmarking Case

- Turbine: IEA 15 MW reference wind turbine, single-rotor configuration.
- Structural configuration: no nacelle and no tower (pure rotor-only loading).
- Purpose: reference benchmark for existing aero-servo-elastic LES codes in a simple uniform inflow.
- OpenFAST input files for this case can be downloaded using the following link: https://github.com/dracafeu95/OpenFAST_Coupling_benchmarkcase_15MW

---

## Case Setup

### Solver and Models

- CFD solver: LES based solver with incompressible Navier-Stokes formulation.
- Wind-turbine model: Actuator Line Model (ALM).
- Mesh type: Cartesian grid.
- Numerical schemes (for YALES2)
  - Space: 4th-order scheme.
  - Time: TFV4A scheme.
- Turbulence model : standard Smagorinsky with C_s = 0.16

---

### Geometrical Setup

- Rotor diameter: D = 240 m.
- Domain size: 18D × 6D × 6D.
- Physical coordinates:
  - x ∈ [0, 4320] m
  - y ∈ [0, 1440] m
  - z ∈ [0, 1440] m
- Turbine configuration: no tower, no nacelle.
- Rotor centre: (3D, 3D, 150 m) i.e. (720 m, 720 m, 150 m). OpenFAST rotor positions are transformed to this reference.
- Number of actuator points per blade: 64.
- Pitch angle: 0°; yaw angle: 0°; cone angle: −4°; tilt angle: −6°.
- Mollification kernel width: ε/Δx = 3.

---

### Mesh and Resolution

- Mesh type: uniform Cartesian grid, no local refinement zones.
- Grid spacing: Δx = Δy = Δz = 4 m. Initial run with a coarser refinement level 8 m resolution.
- Non-dimensional resolution: D/Δx = 60.
- Approximate number of cells:

  N_cells = (4320/4) × (1440/4) × (1440/4) ≈ 1.39 × 10^8 cells.

---

## Inflow and Boundary Conditions

- Inflow: uniform, non-turbulent inflow with U∞ = 8 m/s.
- Boundary conditions:
  - Slip walls on all four lateral walls.
  - Inlet and outlet in streamwise direction.

---

## Turbine Parameters

| Quantity | Value |
|---|---|
| Hub radius | 3.97 m |
| Blade length | 116.03 m |
| Rotor diameter | 240 m |
| Tip-speed ratio (TSR) | 9 |
| Rotation speed | 0.60 rad/s |
| Rotation speed | ≈ 5.73 rpm |
| Cone angle | −4° |
| Controller | off |

---

## Simulation Schedule

- Time step: Δt = 0.025 s.
- Streamwise flow-through time:

  T_FT = Lx / U∞ = 18D / U∞ = 540 s.

- Initial transient discard: 540 s.
- Statistics accumulation: 1080 s.
- Total simulated physical time: 1620 s.

---

## Post-processing and Diagnostics

### Planes for Field Data

- Y-normal plane at rotor centre location: y = 3D.
- Z-normal plane at rotor centre location: z = 3D.
- X-normal plane at rotor location (rotor plane).

For each plane, compute and compare:

- Mean velocity components.
- RMS velocity components.
- Instantaneous and derived vorticity fields.

---

### Line Probes

Line probes are defined along the rotor centreline (vertical direction through the rotor hub) for a set of downstream streamwise locations. 0D location is considered to be rotor position.

- Streamwise probe locations: x/D = −1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9.
- At each x/D, a vertical line probe along the rotor centreline.
- Recorded quantities: mean velocity and RMS velocity components.
- Each line divided into 120 points.

---

### Point Probes

Point probes are defined along the rotor centreline (vertical direction through the rotor hub) for a set of downstream streamwise locations.

- Streamwise probe locations: x/D = −2, −1, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9 at rotor tip locations.
- At each x/D, a point probe at rotor tip height.
- Recorded quantities: time series of instantaneous velocity.

---

## Coupling Inputs

- OpenFAST turbine input files (ElastoDyn, AeroDyn and InflowWind) are to be used.
- The input file case-setup will be distributed together with this document.
- The OpenFAST rotor coordinates are transformed such that the rotor centre coincides with (3D, 3D, 150 m) in the CFD domain.

---

## Summary

This document defines a deterministic benchmark case for existing aero-servo-elastic couplings using the IEA 15 MW reference turbine in uniform, non-turbulent inflow. For any further questions, contact Anand Parinam : a.parinam@tudelft.nl

Following codes are taking part:

- YALES2-OpenFAST: Anand Parinam
- TOSCA-OpenFAST: Sebastiano Stipa
- ASPIRE-OpenFAST: Evert Wiegnant
- AMRWind-OpenFAST: Benito Dello Iacono
