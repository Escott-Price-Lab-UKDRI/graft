#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process TWOSAMPLEMR {
    tag "${meta.trait1}_${meta.trait2}_mr"

    input:
    tuple val(meta), path(exposure, stageAs: 'exposure.tsv'), path(outcome, stageAs: 'outcome.tsv')
    path mr_script

    output:
    tuple val(meta), path("${meta.trait1}_${meta.trait2}"), emit: mr_dir

    script:
    """
    set -euo pipefail

    mkdir -p ${meta.trait1}_${meta.trait2}

    Rscript ${mr_script} \
        --exposure ${exposure} \
        --outcome ${outcome} \
        --exposure_label ${meta.trait1} \
        --outcome_label ${meta.trait2} \
        --outdir ${meta.trait1}_${meta.trait2} \
        --pval_threshold ${params.mr_pval_threshold} \
        --f_threshold ${params.f_stat_thresh} \
        --clump_r2 ${params.mr_clump_r2} \
        --clump_kb ${params.mr_clump_kb} \
        --clump_p1 ${params.clump_p1} \
        --clump_p2 ${params.clump_p2} \
        --mrpresso_nb_distribution ${params.mrpresso_nb_distribution} \
        --mrpresso_signif_threshold ${params.mrpresso_signif_threshold}
    """
}