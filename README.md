# Java Performance Runner
Java Performance Runner aka. `JPR` is my personal efforts to ease Java performance evaluation. Not fund for this. just my hobby project.


## Overview
JPR logically consists of 3 components: runner, post-processing(PP) and data analytics.

 
    +-------------+          +------------------+         +---------------+
    |             |          |                  |         |               |
    | Runner      |----------| post-processsing |-------->| data analytics|
    |             |          |                  |         |               |
    +-------------+          +------------------+         +---------------+
            \____________________/
 	                 Plan

### Runner
Runner is the front-end. It sets up running environments, resolves dependencies and execute plans.
One task is to collect metadata and save them along with running records.

Plan is composite or recursive. The atom is a single run and a PP script. A practical plan lego'es atoms in different dimensions. eg. a comparative plan consists of 2 atoms with and without a JVM option, or N copies Java variants. A long-term tracking plan may have a daily atom and a timer.

Ideally, a plan is defined in a spec-lang. The spec defines hosts, architectures, Java variants or even JVM options in a DSL.
The script engine interprets the spec and generate the composite plans.

Runner certainly must support both local and remote execution. I priorize local first.
Remote execution will reuse the code of local execution. All we need to do is to provision an isolated environment.

### Post-processing(PP)
PP is the middle-end. It processes benchmark outputs, work out performance data and store them to persistance layer.
A PP script is associated with a plan. The reason we separate it out is that PP scripts don't necessarily execute on the specified environment. We may execute PP scripts offline or reschedule them to another host.

PP phase extracts concerning metrics from the outputs of benchmark harness. We plan integrate advanced instrumentation or profilers in runner. eg. extract interesting data from perf data or JFR.

PP script may fail. eg. it is possible that we detect an error from preceding Runner in this phase. It's also possible that Runner succeeds but we fail to collect sufficient data.

PP script may generate Java-specific graph but no performance data are stored. It's for performance analysis. For instance, a flamegraph of allocation.

### Data Analytics
This phase runs some statistical processing and visualization. It separates from PP phase because it is problem-agonostic. We don't need expertises of Java or Linux to develop this phase.
We only require general knowledges on statistics and data visualization.

The only require is that datapoints need to associate with the metadata. Metadata provide details to conduct the same experiment again. In this way, we can backtrack when performance regression is detected.

I prefer using an established data analytics platform to building from scratch.

## Random Ideas
* Why Ruby 2.5?

Ruby is an incredibly flexible object-oriented scripting language. It is easy to define DSLs. Some features such as monkey patch and Mixin can alter framework behaviors easily. I start with MRI but I would dogfood Java and switch to jruby in the future. thefore we cap to Ruby 2.5, the lastest compatible version of jruby for the time being.

* Performance Analysis

I investigated a few other benchmarking systems. Most of them are automatic to run, collect data and visualize them. I would like to have a system which ease performance analysis. From benchmarking scores, developers would feel easy to reproduce, hook up their favorite profilers and seek opportunities to tune it. I envy JMH framework which have integrated a variety of profilers. However, JMH is for miscrobenchs and not all established Java benchmarks will adapt it. I wish I can customize *plan* to integrate with JFR, Linux perf and async-profiler.

* Data format

Data format is the key to truely decouple phases. There are 2 types of data: metadata and performance data. I prefer a textual format for metadata. We need metadata human readable and document database would index them for querying. In contrast, performance data are not supposed to read directly by developers. We expect to select a vendor-independent compact data format for it.
