KMOD=	amd_cppc
SRCS=	amd_cppc.c
SRCS+=	acpi_if.h bus_if.h cpufreq_if.h device_if.h
SRCS+=	opt_acpi.h

.include <bsd.kmod.mk>
