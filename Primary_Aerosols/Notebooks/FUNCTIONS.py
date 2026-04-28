"""
functions for Experiment 'Secondary Aerosols'
"""


import xarray as xr
import numpy as np

# get model level height
def get_dz(ds):
    dz = -1 * ds.z_ifc.diff('height')
    dz = dz.rename({'height':'height_2'})
    dz = dz.assign_coords(height=(dz.height_2 - 1))
    return dz

# Calculate column integrated tracer mass (tracer load)
def tracer_load(tr,rho,dz):
    m_tr = tr * rho * dz
    m_tr = m_tr.sum('height_2')
    m_tr = m_tr.squeeze()
    return m_tr


def lat_lon_cell_area(lats,lons):
    earth_rad = 6371008.8
    lats_diff = lats[1]-lats[0]
    lats_new  = np.concatenate((lats-lats_diff,np.array([lats[-1]+lats_diff])))
    lons_diff = lons[1]-lons[0]
    lons_new  = np.concatenate((lons-lons_diff,np.array([lons[-1]+lons_diff])))
    lat_rad   = np.radians(lats_new)
    lon_rad   = np.radians(lons_new)

    area = np.zeros((len(lat_rad)-1,len(lon_rad)-1))
    for i_lat in range(0,(len(lat_rad)-1)):
        for i_lon in range(0,(len(lon_rad)-1)):
            area[i_lat,i_lon] = np.abs((lon_rad[i_lon] - lon_rad[i_lon+1]) * (np.sin(lat_rad[i_lat]) - np.sin(lat_rad[i_lat+1])) * (earth_rad**2))

    return area