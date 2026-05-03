#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { PREP_BULK_QTL_FOR_SMR } from '../../../modules/local/smr_bulk'
include { PREP_GWAS_FOR_SMR }     from '../../../modules/local/smr_bulk'
include { BULK_SMR_HEIDI }        from '../../../modules/local/smr_bulk'
include { GRAB_BULK_SMR_HITS }    from '../../../modules/local/smr_bulk'

workflow SMR_BULK {

    take:
    ch_gwas
    qtl_manifest
    prep_qtl_script
    format_gwas_script
    grab_hits_script
    gtf_file

    main:

    ch_bulk_qtls = qtl_manifest
        .splitCsv(header: true, sep: '\t')
        .filter { row ->
            row.qtl_type == "bulk"
        }
        .map { row ->
            def meta = [
                id           : row.id,
                qtl_type     : row.qtl_type,
                qtl_modality : row.qtl_modality,
                cell_type    : row.cell_type,
                snp_col      : row.snp_col,
                beta_col     : row.beta_col,
                se_col       : row.se_col,
                ea_col       : row.ea_col,
                oa_col       : row.oa_col,
                eaf_col      : row.eaf_col,
                pval_col     : row.pval_col,
                n_col        : row.n_col,
                gene_col     : row.gene_col,
                chr_col      : row.chr_col,
                bp_col       : row.bp_col,
                build        : row.build
            ]

            tuple(meta, file(row.qtl_file))
        }

    ch_prepped_qtls = PREP_BULK_QTL_FOR_SMR(
        ch_bulk_qtls,
        prep_qtl_script,
        gtf_file
    ).smr_qtl

    ch_prepped_gwas = PREP_GWAS_FOR_SMR(
        ch_gwas,
        format_gwas_script
    ).smr_gwas

    ch_smr_input = ch_prepped_gwas
        .combine(ch_prepped_qtls)

    ch_smr_results = BULK_SMR_HEIDI(ch_smr_input).smr_res

    ch_smr_hits = GRAB_BULK_SMR_HITS(
        ch_smr_results,
        grab_hits_script
    ).hits

    emit:
    smr_results = ch_smr_results
    smr_hits    = ch_smr_hits
}