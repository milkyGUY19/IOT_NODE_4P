#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/579785578/plib_clock.o ${OBJECTDIR}/_ext/581935064/plib_evsys.o ${OBJECTDIR}/_ext/119507450/plib_nvic.o ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o ${OBJECTDIR}/_ext/119454299/plib_port.o ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o ${OBJECTDIR}/_ext/187242624/initialization.o ${OBJECTDIR}/_ext/187242624/interrupts.o ${OBJECTDIR}/_ext/187242624/exceptions.o ${OBJECTDIR}/_ext/187242624/startup_xc32.o ${OBJECTDIR}/_ext/187242624/libc_syscalls.o ${OBJECTDIR}/_ext/1212761987/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/579785578/plib_clock.o.d ${OBJECTDIR}/_ext/581935064/plib_evsys.o.d ${OBJECTDIR}/_ext/119507450/plib_nvic.o.d ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o.d ${OBJECTDIR}/_ext/119454299/plib_port.o.d ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o.d ${OBJECTDIR}/_ext/187242624/initialization.o.d ${OBJECTDIR}/_ext/187242624/interrupts.o.d ${OBJECTDIR}/_ext/187242624/exceptions.o.d ${OBJECTDIR}/_ext/187242624/startup_xc32.o.d ${OBJECTDIR}/_ext/187242624/libc_syscalls.o.d ${OBJECTDIR}/_ext/1212761987/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/579785578/plib_clock.o ${OBJECTDIR}/_ext/581935064/plib_evsys.o ${OBJECTDIR}/_ext/119507450/plib_nvic.o ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o ${OBJECTDIR}/_ext/119454299/plib_port.o ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o ${OBJECTDIR}/_ext/187242624/initialization.o ${OBJECTDIR}/_ext/187242624/interrupts.o ${OBJECTDIR}/_ext/187242624/exceptions.o ${OBJECTDIR}/_ext/187242624/startup_xc32.o ${OBJECTDIR}/_ext/187242624/libc_syscalls.o ${OBJECTDIR}/_ext/1212761987/main.o

# Source Files
SOURCEFILES=E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c

# Pack Options 
PACK_COMMON_OPTIONS=-I "${CMSIS_DIR}/CMSIS/Core/Include"



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=32CM5164JH01048
MP_LINKER_FILE_OPTION=,--script="E:\4rocnik\IoT\Ve_Skole\JakubJarda_Sbernice\src\config\default\PIC32CM5164JH01048.ld"
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/579785578/plib_clock.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c  .generated_files/flags/default/ca6621385463566633f67eebab97f04e990f813 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/579785578" 
	@${RM} ${OBJECTDIR}/_ext/579785578/plib_clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/579785578/plib_clock.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/579785578/plib_clock.o.d" -o ${OBJECTDIR}/_ext/579785578/plib_clock.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/581935064/plib_evsys.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c  .generated_files/flags/default/ff3cc23c1b8ed95915a2f30277dec8c06e733e97 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/581935064" 
	@${RM} ${OBJECTDIR}/_ext/581935064/plib_evsys.o.d 
	@${RM} ${OBJECTDIR}/_ext/581935064/plib_evsys.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/581935064/plib_evsys.o.d" -o ${OBJECTDIR}/_ext/581935064/plib_evsys.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/119507450/plib_nvic.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c  .generated_files/flags/default/77d3a9df4f5868a7286b0b7f9fdbaac9df88e5d2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/119507450" 
	@${RM} ${OBJECTDIR}/_ext/119507450/plib_nvic.o.d 
	@${RM} ${OBJECTDIR}/_ext/119507450/plib_nvic.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/119507450/plib_nvic.o.d" -o ${OBJECTDIR}/_ext/119507450/plib_nvic.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c  .generated_files/flags/default/b4c72ad6d2c7433fff8f7994509f57d17b362dc8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/285254636" 
	@${RM} ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o.d" -o ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/119454299/plib_port.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c  .generated_files/flags/default/a4be34fe54a68ca97d40e2ed90884e3228c21fb3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/119454299" 
	@${RM} ${OBJECTDIR}/_ext/119454299/plib_port.o.d 
	@${RM} ${OBJECTDIR}/_ext/119454299/plib_port.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/119454299/plib_port.o.d" -o ${OBJECTDIR}/_ext/119454299/plib_port.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1479324614/xc32_monitor.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c  .generated_files/flags/default/3fdc33f625c40802ae95e3c7f3e9086bef041106 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1479324614" 
	@${RM} ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/1479324614/xc32_monitor.o.d" -o ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/initialization.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c  .generated_files/flags/default/2e350b66a57ea65403caa0ecc9519af5f51a2633 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/initialization.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/initialization.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/initialization.o.d" -o ${OBJECTDIR}/_ext/187242624/initialization.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/interrupts.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c  .generated_files/flags/default/5083eb58de97c9dbfa3fe4234b31c68d3b7cc919 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/interrupts.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/interrupts.o.d" -o ${OBJECTDIR}/_ext/187242624/interrupts.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/exceptions.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c  .generated_files/flags/default/1bbcd1b0ce626a83fc91d4f5223a182abff98ea1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/exceptions.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/exceptions.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/exceptions.o.d" -o ${OBJECTDIR}/_ext/187242624/exceptions.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/startup_xc32.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c  .generated_files/flags/default/41d59ade04c0d8d919daff1bad0467476841ea67 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/startup_xc32.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/startup_xc32.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/startup_xc32.o.d" -o ${OBJECTDIR}/_ext/187242624/startup_xc32.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/libc_syscalls.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c  .generated_files/flags/default/2542a3be673c610215975e4bbef206e5ede7eaa6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/libc_syscalls.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/libc_syscalls.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/libc_syscalls.o.d" -o ${OBJECTDIR}/_ext/187242624/libc_syscalls.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1212761987/main.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c  .generated_files/flags/default/6f7aac10f5e0fce77c837b4f8d9164d513526a67 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1212761987" 
	@${RM} ${OBJECTDIR}/_ext/1212761987/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1212761987/main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/1212761987/main.o.d" -o ${OBJECTDIR}/_ext/1212761987/main.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
else
${OBJECTDIR}/_ext/579785578/plib_clock.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c  .generated_files/flags/default/483fdf77e5da9b32db1f5a96a4a4f3693051c818 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/579785578" 
	@${RM} ${OBJECTDIR}/_ext/579785578/plib_clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/579785578/plib_clock.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/579785578/plib_clock.o.d" -o ${OBJECTDIR}/_ext/579785578/plib_clock.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/clock/plib_clock.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/581935064/plib_evsys.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c  .generated_files/flags/default/92338b30f87ea2759e072737a8308030bb8686cb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/581935064" 
	@${RM} ${OBJECTDIR}/_ext/581935064/plib_evsys.o.d 
	@${RM} ${OBJECTDIR}/_ext/581935064/plib_evsys.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/581935064/plib_evsys.o.d" -o ${OBJECTDIR}/_ext/581935064/plib_evsys.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/evsys/plib_evsys.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/119507450/plib_nvic.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c  .generated_files/flags/default/34baf9e9f5d2cce1cfb06474448485ce95439cd6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/119507450" 
	@${RM} ${OBJECTDIR}/_ext/119507450/plib_nvic.o.d 
	@${RM} ${OBJECTDIR}/_ext/119507450/plib_nvic.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/119507450/plib_nvic.o.d" -o ${OBJECTDIR}/_ext/119507450/plib_nvic.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvic/plib_nvic.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c  .generated_files/flags/default/f9d6966511e0b451a9b62b17ecc622fcec4cb792 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/285254636" 
	@${RM} ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o.d" -o ${OBJECTDIR}/_ext/285254636/plib_nvmctrl.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/nvmctrl/plib_nvmctrl.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/119454299/plib_port.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c  .generated_files/flags/default/a9c191434257aca1d41f1d650cc196c23acdfe59 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/119454299" 
	@${RM} ${OBJECTDIR}/_ext/119454299/plib_port.o.d 
	@${RM} ${OBJECTDIR}/_ext/119454299/plib_port.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/119454299/plib_port.o.d" -o ${OBJECTDIR}/_ext/119454299/plib_port.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/peripheral/port/plib_port.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1479324614/xc32_monitor.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c  .generated_files/flags/default/630a5774a7b2d526a92687a77541bb5c075f300d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1479324614" 
	@${RM} ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/1479324614/xc32_monitor.o.d" -o ${OBJECTDIR}/_ext/1479324614/xc32_monitor.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/stdio/xc32_monitor.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/initialization.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c  .generated_files/flags/default/ff3b05d11846752ee1ffceee6077cddd07f5ce05 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/initialization.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/initialization.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/initialization.o.d" -o ${OBJECTDIR}/_ext/187242624/initialization.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/initialization.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/interrupts.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c  .generated_files/flags/default/74153140149b9fc497c213ce385e87c02c4f45df .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/interrupts.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/interrupts.o.d" -o ${OBJECTDIR}/_ext/187242624/interrupts.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/interrupts.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/exceptions.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c  .generated_files/flags/default/90d792dd607a3c3a8893cadb592b45b510bed7e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/exceptions.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/exceptions.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/exceptions.o.d" -o ${OBJECTDIR}/_ext/187242624/exceptions.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/exceptions.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/startup_xc32.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c  .generated_files/flags/default/38a2bd407992462385b4f7909455810917105b86 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/startup_xc32.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/startup_xc32.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/startup_xc32.o.d" -o ${OBJECTDIR}/_ext/187242624/startup_xc32.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/startup_xc32.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/187242624/libc_syscalls.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c  .generated_files/flags/default/1c1b15431aeeb94310ac17c39cc2902338730f60 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/187242624" 
	@${RM} ${OBJECTDIR}/_ext/187242624/libc_syscalls.o.d 
	@${RM} ${OBJECTDIR}/_ext/187242624/libc_syscalls.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/187242624/libc_syscalls.o.d" -o ${OBJECTDIR}/_ext/187242624/libc_syscalls.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/libc_syscalls.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1212761987/main.o: E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c  .generated_files/flags/default/678942b94053997578b1f3a77402925409e13761 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1212761987" 
	@${RM} ${OBJECTDIR}/_ext/1212761987/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1212761987/main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -fno-common -I"../src" -I"../src/config/default" -I"../src/packs/CMSIS/" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/PIC32CM5164JH01048_DFP" -MP -MMD -MF "${OBJECTDIR}/_ext/1212761987/main.o.d" -o ${OBJECTDIR}/_ext/1212761987/main.o E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/main.c    -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}/PIC32CM-JH01" ${PACK_COMMON_OPTIONS} 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compileCPP
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/PIC32CM5164JH01048.ld
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -g   -mprocessor=$(MP_PROCESSOR_OPTION)  -mno-device-startup-code -o ${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D=__DEBUG_D,--defsym=_min_heap_size=512,--gc-sections,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--memorysummary,${DISTDIR}/memoryfile.xml -mdfp="${DFP_DIR}/PIC32CM-JH01"
	
else
${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   E:/4rocnik/IoT/Ve_Skole/JakubJarda_Sbernice/src/config/default/PIC32CM5164JH01048.ld
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mprocessor=$(MP_PROCESSOR_OPTION)  -mno-device-startup-code -o ${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=_min_heap_size=512,--gc-sections,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--memorysummary,${DISTDIR}/memoryfile.xml -mdfp="${DFP_DIR}/PIC32CM-JH01"
	${MP_CC_DIR}\\xc32-bin2hex ${DISTDIR}/IOT_NODE_4P.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} 
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
