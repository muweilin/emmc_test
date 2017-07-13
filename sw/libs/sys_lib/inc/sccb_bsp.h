#ifndef _SCCB_H_
#define _SCCB_H_

void SCCB_init(void);
uint8_t SCCB_WriteByte(uint8_t WriteAddress, uint8_t SendByte);
uint8_t SCCB_ReadByte(uint8_t ReadAddress);

#endif
