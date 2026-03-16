#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { LDSC } from "../modules/local/ldsc"

workflow LDSC_PAIRWISE {
  take:
  ch_pairs
  ldsc_r
  hm3_snplist
  ld_chr_dir
  wld_dir

  main:
  ch_ldsc = LDSC(ch_pairs, ldsc_r, hm3_snplist, ld_chr_dir, wld_dir)

  emit:
  ldsc = ch_ldsc
}