FROM ubuntu:22.04

RUN apt update 
RUN apt install --yes --no-install-recommends build-essential
RUN apt install --yes --no-install-recommends libc6-i386
RUN apt install --yes --no-install-recommends libusb-0.1-4
RUN apt install --yes --no-install-recommends libgconf-2-4
RUN apt install --yes --no-install-recommends git

WORKDIR /ccs_install

ADD CCS10.2.0.00009_linux-x64.tar.gz /ccs_install
COPY ti_cgt_c2000_22.6.0.LTS_linux-x64_installer.bin /ccs_install
COPY bios_6_83_00_18.run /ccs_install

RUN ls -la /ccs_install

RUN chmod +x /ccs_install/CCS10.2.0.00009_linux-x64/ccs_setup_10.2.0.00009.run && \
    /ccs_install/CCS10.2.0.00009_linux-x64/ccs_setup_10.2.0.00009.run --mode unattended --enable-components PF_C28 --prefix /opt/ti/ccs1020

RUN chmod +x /ccs_install/ti_cgt_c2000_22.6.0.LTS_linux-x64_installer.bin && \
    /ccs_install/ti_cgt_c2000_22.6.0.LTS_linux-x64_installer.bin --mode unattended --prefix /opt/ti

RUN chmod +x /ccs_install/bios_6_83_00_18.run && \
    /ccs_install/bios_6_83_00_18.run --mode unattended --prefix /opt/ti

WORKDIR /ccs_workspace

RUN /opt/ti/ccs1020/ccs/eclipse/eclipse -noSplash -data /ccs_workspace -application com.ti.common.core.initialize -rtsc.productDiscoveryPath "/opt/ti"
RUN /opt/ti/ccs1020/ccs/eclipse/eclipse -noSplash -data /ccs_workspace -application com.ti.common.core.initialize -ccs.productDiscoveryPath "/opt/ti"
RUN /opt/ti/ccs1020/ccs/eclipse/eclipse -noSplash -data /ccs_workspace -application com.ti.common.core.initialize -ccs.toolDiscoveryPath "/opt/ti"

RUN rm -rf /ccs_install

WORKDIR /