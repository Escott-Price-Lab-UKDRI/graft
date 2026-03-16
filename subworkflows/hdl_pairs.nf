#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { HDL_L } from '../modules/local/hdl_l'

workflow HDL_L_PAIRS {
  take:
  ch_hdl_in
  hdl_l_r
  ld_path
  bim_path

  main:
  HDL_L(ch_hdl_in, hdl_l_r, ld_path, bim_path)
}