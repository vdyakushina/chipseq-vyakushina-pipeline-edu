rule callpeak:
    input:
        treatment="results/bams_sorted/{sample}_{genome}.sorted.bam"
    output:
        multiext("results/macs2/{sample}_{genome}",
                 "_peaks.xls",   ### required
                 ### optional output files
                 "_peaks.narrowPeak",
                 )
    log:
        "logs/macs2/{sample}_{genome}/callpeak.log"
    params:
        "-f BAM -g hs"
    wrapper:
        "0.74.0/bio/macs2/callpeak"
