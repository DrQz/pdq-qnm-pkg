\begin{verbatim}
#!/usr/bin/env python
import pdq

processors  = 4     # Same as spam farm example
arrivalRate = 0.099 # Jobs per hour (very low arrivals)
crunchTime  = 10.0  # Hours (very long service time)

pdq.Init("ORCA LA Model")
s = pdq.CreateOpen("Crunch", arrivalRate)
n = pdq.CreateNode("HPCnode", int(processors), pdq.MSQ)
pdq.SetDemand("HPCnode", "Crunch", crunchTime)
pdq.SetWUnit("Jobs")
pdq.SetTUnit("Hour")
pdq.Solve(pdq.CANON)
pdq.Report()
\end{verbatim}