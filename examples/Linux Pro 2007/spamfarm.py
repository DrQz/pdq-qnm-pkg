\begin{verbatim}
#!/usr/bin/env python
import pdq

# Measured performance parameters 
cpusPerServer = 4
emailThruput  = 2376 # emails per hour
scannerTime   = 6.0  # seconds per email

pdq.Init("Spam Farm Model")
# Timebase is SECONDS ...
nstreams = pdq.CreateOpen("Email", float(emailThruput)/3600)
nnodes   = pdq.CreateNode("spamCan", int(cpusPerServer), pdq.MSQ)
pdq.SetDemand("spamCan", "Email", scannerTime)
pdq.Solve(pdq.CANON)
pdq.Report()
\end{verbatim}