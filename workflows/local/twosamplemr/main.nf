#!/usr/bin/env nextflow
nextflow.enable.dsl=2

import neurobridge.ParamUtils
import neurobridge.PairSamplesheet

include { TWOSAMPLEMR_PREP } from '../../../subworkflows/local/twosamplemr/main'
include { TWOSAMPLEMR }      from '../../../modules/local/twosamplemr'

workflow STAGE1_TWOSAMPLEMR {

    main:
    ParamUtils.requireParam(params.pairs, "pairs")
    ParamUtils.requireParam(params.outdir, "outdir")

    def qc_dir = file("${params.outdir}/QC")
    if( !qc_dir.exists() ) {
        error "QC directory not found at ${params.outdir}/QC. Run STAGE1_QC or STAGE1_LDSC prep first."
    }

    mr_script = file("${projectDir}/bin/mr-pipeline.R")
    if( !mr_script.exists() ) {
        error "MR script not found: ${mr_script}"
    }

    ch_pairs = Channel
        .fromPath(params.pairs, checkIfExists: true)
        .splitCsv(header: true, sep: '\t')
        .map { row ->
            def meta = PairSamplesheet.buildMeta(row)
            meta.id = "${meta.trait1}_${meta.trait2}"
            meta
        }

    ch_mr_in = TWOSAMPLEMR_PREP(ch_pairs).mr_input

    TWOSAMPLEMR(ch_mr_in, mr_script)
}