#!/usr/bin/env nextflow
nextflow.enable.dsl=2

import neurobridge.ParamUtils
import neurobridge.GWASSamplesheet
import neurobridge.PairSamplesheet

include { PREP_LDSC_INPUT } from '../../../subworkflows/local/ldsc/main'
include { LDSC }            from '../../../modules/local/ldsc'

workflow STAGE1_LDSC {

  main:
  ParamUtils.requireParam(params.input, "input")
  ParamUtils.requireParam(params.pairs, "pairs")

  ch_in = Channel
    .fromPath(params.input, checkIfExists: true)
    .splitCsv(header:true, sep:'\t')
    .map { row ->
      def meta = GWASSamplesheet.buildMeta(row)
      tuple(meta, file(row.gwas))
    }

  qc_script = file("${projectDir}/bin/qc_gwas.py")
  neff_script = file("${projectDir}/bin/compute_neff.py")
  ldsc_r = file("${projectDir}/bin/ldsc.R")

  hm3_snplist = file("${projectDir}/ref/ldsc/w_hm3.snplist")
  ld_chr_dir = file("${projectDir}/ref/ldsc/eur_w_ld_chr")
  wld_dir = file("${projectDir}/ref/ldsc/weights_hm3_no_hla")

  ch_sum = PREP_LDSC_INPUT(ch_in, qc_script, neff_script).ldsc_input

  ch_pairs = Channel
    .fromPath(params.pairs, checkIfExists: true)
    .splitCsv(header:true, sep:'\t')
    .map { row ->
      def meta = PairSamplesheet.buildMeta(row)
      tuple(meta.trait1, meta.trait2, meta)
    }

  ch_with_t1 = ch_pairs
    .join(ch_sum, by: 0)
    .map { trait1, trait2, meta, f1 ->
      tuple(trait2, meta, f1)
    }

  ch_ldsc_in = ch_with_t1
    .join(ch_sum, by: 0)
    .map { trait2, meta, f1, f2 ->
      tuple(meta, f1, f2)
    }

  LDSC(ch_ldsc_in, ldsc_r, hm3_snplist, ld_chr_dir, wld_dir)
}