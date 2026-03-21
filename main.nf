#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/neurobridge
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Started on October 2025
    Escott-Price Lab; UK Dementia Research Institute
    Dev: Guillermo Comesaña Cimadevila
    GitHub: https://github.com/guillermocomesanacimadevila/neurobridge

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/ 

include { STAGE1_QC }   from './workflows/local/qc/main'
include { STAGE1_LDSC } from './workflows/local/ldsc/main'
include { STAGE1_HDL }  from './workflows/local/hdl/main'

workflow {
    STAGE1_QC()
    STAGE1_LDSC()
    STAGE1_HDL()
}
