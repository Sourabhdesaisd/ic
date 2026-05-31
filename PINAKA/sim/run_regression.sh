#!/bin/bash

MODE=$1
ISA=$2
RUNS=${3:-100}

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REG_DIR="regression_${MODE}_${TIMESTAMP}"

PASS_COUNT=0
FAIL_COUNT=0

SUMMARY_FILE="$REG_DIR/summary.txt"
REPORT_FILE="$REG_DIR/final_report.txt"

mkdir -p "$REG_DIR"

echo "Cleaning Xcelium locks..."
cd ~/Desktop/PINAKA/third_party/riscv-dv || exit 1
rm -rf xcelium.d INCA_libs

cd ~/Desktop/PINAKA/sim || exit 1
rm -rf xcelium.d

echo "Clean done"
echo "--------------------------------"

echo "RUN_NAME | RESULT | SEED" > "$SUMMARY_FILE"
echo "------------------------" >> "$SUMMARY_FILE"

echo "========================================="
echo " Regression Started"
echo " MODE : $MODE"
echo " ISA  : $ISA"
echo " RUNS : $RUNS"
echo "========================================="

for ((i=1; i<=RUNS; i++))
do
    SEED=$RANDOM
    PREFIX="${MODE}_${SEED}"
    RUN_NAME="${i}_${MODE}_${SEED}"
    RUN_DIR="$REG_DIR/$RUN_NAME"

    mkdir -p "$RUN_DIR"

    echo ""
    echo "========== RUN $i ($RUN_NAME) =========="

    make MODE=$MODE SEED=$SEED ISA="$ISA" > "$REG_DIR/${RUN_NAME}.log" 2>&1

    CMP_LOG="results/logs/${PREFIX}/compare.log"

    sleep 1

    if [ ! -f "$CMP_LOG" ]; then
        echo "RUN $i : FAIL (NO_COMPARE)"
        echo "$RUN_NAME | FAIL (NO_COMPARE) | $SEED" >> "$SUMMARY_FILE"
        ((FAIL_COUNT++))


        elif [ "$MODE" = "atomic" ]; then

        PC_FAIL=$(grep "^PC" "$CMP_LOG" | awk '{print $7}')
        INSTR_FAIL=$(grep "^INSTR" "$CMP_LOG" | awk '{print $7}')
        RD_FAIL=$(grep "^RD" "$CMP_LOG" | awk '{print $7}')
        WB_FAIL=$(grep "^WB" "$CMP_LOG" | awk '{print $7}')
        MEM_ADDR_FAIL=$(grep "^MEM_ADDR" "$CMP_LOG" | awk '{print $7}')
        MEM_DATA_FAIL=$(grep "^MEM_DATA" "$CMP_LOG" | awk '{print $7}')
    
        PC_FAIL=${PC_FAIL:-0}
        INSTR_FAIL=${INSTR_FAIL:-0}
        RD_FAIL=${RD_FAIL:-0}
        WB_FAIL=${WB_FAIL:-0}
        MEM_ADDR_FAIL=${MEM_ADDR_FAIL:-0}
        MEM_DATA_FAIL=${MEM_DATA_FAIL:-0}
    
        if [ "$PC_FAIL" -eq 0 ] && \
           [ "$INSTR_FAIL" -eq 0 ] && \
           [ "$RD_FAIL" -eq 0 ] && \
           [ "$MEM_ADDR_FAIL" -eq 0 ] && \
           [ "$MEM_DATA_FAIL" -eq 0 ] && \
           [ "$WB_FAIL" -le 1 ]; then
    
            echo "RUN $i : PASS"
            echo "$RUN_NAME | PASS | $SEED" >> "$SUMMARY_FILE"
            ((PASS_COUNT++))
        else
            echo "RUN $i : FAIL"
            echo "$RUN_NAME | FAIL | $SEED" >> "$SUMMARY_FILE"
            ((FAIL_COUNT++))
    
            echo "---- ATOMIC FAIL COUNT ----"
            echo "PC_FAIL       = $PC_FAIL"
            echo "INSTR_FAIL    = $INSTR_FAIL"
            echo "RD_FAIL       = $RD_FAIL"
            echo "WB_FAIL       = $WB_FAIL"
            echo "MEM_ADDR_FAIL = $MEM_ADDR_FAIL"
            echo "MEM_DATA_FAIL = $MEM_DATA_FAIL"
        fi


    elif [ "$MODE" = "compressed" ]; then

        TOTAL_FAILED=$(grep "Total Failed" "$CMP_LOG" | awk -F"," '{print $2}' | tr -d " )")

        if [ "$TOTAL_FAILED" = "0" ]; then
            echo "RUN $i : PASS"
            echo "$RUN_NAME | PASS | $SEED" >> "$SUMMARY_FILE"
            ((PASS_COUNT++))
        else
            echo "RUN $i : FAIL"
            echo "$RUN_NAME | FAIL | $SEED" >> "$SUMMARY_FILE"
            ((FAIL_COUNT++))

            echo "---- COMPRESSED FAIL INFO ----"
            grep -E "Total Failed|FAIL|FAILED|MISMATCH|ERROR" "$CMP_LOG"
        fi

    else

        if grep -q "ALL INSTRUCTIONS MATCHED" "$CMP_LOG"; then
            echo "RUN $i : PASS"
            echo "$RUN_NAME | PASS | $SEED" >> "$SUMMARY_FILE"
            ((PASS_COUNT++))
        else
            echo "RUN $i : FAIL"
            echo "$RUN_NAME | FAIL | $SEED" >> "$SUMMARY_FILE"
            ((FAIL_COUNT++))

            echo "---- ERROR ----"
            grep -E "ERROR|FAILURES|FAILED|FAIL" "$CMP_LOG"
        fi

    fi

    cp "$REG_DIR/${RUN_NAME}.log" "$RUN_DIR/" 2>/dev/null
    cp -r "results/logs/${PREFIX}" "$RUN_DIR/" 2>/dev/null
done

PASS_PERCENT=$((PASS_COUNT * 100 / RUNS))

{
echo ""
echo "========================================="
echo "         REGRESSION REPORT"
echo "========================================="
echo "MODE        : $MODE"
echo "ISA         : $ISA"
echo "TOTAL RUNS  : $RUNS"
echo "PASS COUNT  : $PASS_COUNT"
echo "FAIL COUNT  : $FAIL_COUNT"
echo "PASS %      : $PASS_PERCENT%"
echo "========================================="
} > "$REPORT_FILE"

echo ""
echo "========================================="
echo " FINAL SUMMARY"
echo "========================================="
echo "PASS : $PASS_COUNT"
echo "FAIL : $FAIL_COUNT"
echo "PASS % : $PASS_PERCENT%"
echo "========================================="
echo "Summary file : $SUMMARY_FILE"
echo "Report file  : $REPORT_FILE"
