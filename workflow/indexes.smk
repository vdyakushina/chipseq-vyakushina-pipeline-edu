rule download_reference:
    output: "resources/indexes/{genome}/{genome}.fa.gz"
    log: "logs/indexes/{genome}/{genome}.fa.gz.log"
    # as an alternative - use `bio/reference/ensembl-sequence` wrapper
    shell:
        "wget -O {output} http://hgdownload.soe.ucsc.edu/goldenPath/{wildcards.genome}/bigZips/{wildcards.genome}.fa.gz &> {log}"

rule bowtie2_index:
    input:
        reference=ancient(rules.download_reference.output)
    output:
        multiext(
            'results/indexes/{genome}/{genome}',
            '.1.bt2','.2.bt2','.3.bt2','.4.bt2','.rev.1.bt2','.rev.2.bt2',
        ),
    log: "logs/indexes/{genome}.log"
    benchmark: "benchmarks/indexes/{genome}.txt"

    threads: config['bowtie2_index']['threads']
    params:
        extra=config['bowtie2_index']['extra']
    # Wrapper uses old 2.4.1 bowtie2, which doesn't work on my mac
    # let's use custom conda env file with another bowtie2 version
    conda: "../envs/bowtie.yaml"
    wrapper:
        "0.74.0/bio/bowtie2/build"