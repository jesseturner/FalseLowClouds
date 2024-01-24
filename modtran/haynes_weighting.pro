; Written by John Haynes (john.haynes@colostate.edu)
; Last modified 2023/07/19

; ---------------------------------------------------------------------------
; USER-DEFINED PARAMETERS
; ---------------------------------------------------------------------------

  fin_tp8 = '/Users/haynes/Desktop/mls_b1f_1.0.tp8'
  fin_rsr = 'rtcoef_eos_1_modis-shifted_srf_ch17.txt'
  rsr_type = 'modis'
  output_trans = 'output_trans.txt'
  output_weighting = 'output_weighting.txt'

; -----------------------------------------------------------------------------
; MAIN 
; -----------------------------------------------------------------------------
 
 ; Read spectral response function for appropriate channel

  if rsr_type eq 'abi' or rsr_type eq 'metimage' then begin  
    read_abi_rsr, fin_rsr, wl_rsr_raw, rsr_raw
  endif else if rsr_type eq 'modis' then begin
    read_modis_rsr, fin_rsr, wl_rsr_raw, rsr_raw
    wl_rsr_raw = reverse(wl_rsr_raw)
    rsr_raw = reverse(rsr_raw)
  endif else if rsr_type eq 'geoxo' then begin
    read_geoxo_rsr, fin_rsr, wl_rsr_raw, rsr_raw
  endif else begin
    message, 'Unknown value of rsr_type'
  endelse
 
; Get transmission on levels for all wavenumbers in tp8 file

  read_profile_allbands, fin_tp8, alt_lev, trans_lev, wl, /wn2wl, $
    /quiet
  nlev = n_elements(alt_lev)
  nwl = n_elements(wl)
  
; Convolve transmittances with spectral response function

  if min(wl_rsr_raw) lt min(wl) or max(wl_rsr_raw) gt max(wl) then $
    message, 'RSR wavelengths are not bounded by MODTRAN run'
  rsr = linear_interpolate(wl_rsr_raw,rsr_raw,wl,status=status)
  rsr[where(status ne 0)] = 0.
  trans_lev_conv = fltarr(nlev)
  for j=0L,nlev-1 do begin
    tmp1 = int_tabulated(wl,trans_lev[*,j]*rsr)
    tmp2 = int_tabulated(wl,rsr)
    trans_lev_conv[j] = tmp1/tmp2
  endfor
 
 ; Create layers between levels to calculate weighting function

  nlay = n_elements(alt_lev) - 1
  alt_lay = fltarr(nlay)
  weightfunc_lay_conv = fltarr(nlay)
  for j=0L,nlev-2 do begin
    alt_lay[j] = mean([alt_lev[j],alt_lev[j+1]])
    weightfunc_lay_conv[j] = (trans_lev_conv[j]-trans_lev_conv[j+1]) $
      / (alt_lev[j]-alt_lev[j+1])
  endfor

; Write output

  fmt1 = '(A10,10A12)'
  fmt2 = '(F11.5, F11.8)'

  openw, lun, output_trans, /get_lun
  printf, lun, format=fmt1, 'Alt (km)', 'Trans'
  for j=0L,nlev-1 do begin
    printf, lun, format=fmt2, alt_lev[j], trans_lev_conv[j]
  endfor
  free_lun, lun

  openw, lun, output_weighting, /get_lun
  printf, lun, format=fmt1, 'Alt (km)', 'Weighting'
  for j=0L,nlev-2 do begin
    printf, lun, format=fmt2, alt_lay[j], weightfunc_lay_conv[j]
  endfor
  free_lun, lun

  print, 'Transmittance and weighting functions written to files'

  end
  