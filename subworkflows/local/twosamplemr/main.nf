#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { TWOSAMPLEMR } from '../../../modules/local/twosamplemr'

workflow TWOSAMPLEMR_PREP {

    take:
    ch_pairs

    main:
    ch_qc = Channel
        .fromPath("${params.outdir}/QC/*/*_ldsc_ready_neff.tsv", checkIfExists: true)
        .ifEmpty { error "No QC-ready NEFF files found under ${params.outdir}/QC. Run STAGE1_QC or STAGE1_LDSC prep first." }
        .map { f -> 
            def trait = f.getBaseName().replaceFirst(/_ldsc_ready_neff$/, '') 
            tuple(trait, f)
        }

    ch_exp = ch_pairs
        .map { meta -> tuple(meta.trait1, meta) }
        .join(ch_qc, by: 0)
        .map { trait1, meta, exposure_file -> 
            tuple(meta.trait1, meta, exposure_file)
        }

    ch_mr = ch_exp
        .join(ch_qc, by: 0)
        .map { trait2, meta, exposure_file, outcome_file -> 
            tuple(meta, exposure_file, outcome_file)
        }

    emit:
    mr_input = ch_mr

}